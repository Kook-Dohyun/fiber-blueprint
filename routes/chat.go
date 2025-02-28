package routes

import (
	"encoding/json"
	"fiber_server/config"
	"fiber_server/model"
	"fiber_server/utils"

	"github.com/gofiber/fiber/v3"
	"gorm.io/gorm"
)

// 추가: FCM 메시지 크기 제한을 위한 상수
const (
	maxFCMTextLength    = 100
	maxFCMMediaURLCount = 4
)

// 추가: 알림용 요약 메시지 구조체
type NotificationSummaryMessage struct {
	ID          string   `json:"id"`
	ChatRoomID  string   `json:"chat_room_id"`
	SenderID    string   `json:"sender_id"`
	TextSummary string   `json:"text_summary,omitempty"`
	HasMedia    bool     `json:"has_media,omitempty"`
	MediaURLs   []string `json:"media_urls,omitempty"`
}

func SetupChatRoutes(app *fiber.App) {
	chat := app.Group("/chat")

	// 채팅방 관련 엔드포인트
	chat.Post("/rooms", createChatRoom)
	chat.Get("/rooms/persona/:myPersonaId/list", listPersonaChatRooms)
	chat.Get("/rooms/persona/:myPersonaId/:targetPersonaId", getOrCreatePersonaChatRoom)
	chat.Get("/rooms/:id", getChatRoom)
	chat.Delete("/rooms/:id", deleteChatRoom)

	// 채팅방 참가자 관련 엔드포인트
	chat.Post("/rooms/:id/participants", addChatRoomParticipant)
	chat.Delete("/rooms/:id/participants/:personaId", removeChatRoomParticipant)
	chat.Get("/rooms/:id/participants", getChatRoomParticipants)

	// 설정 관련 엔드포인트
	chat.Put("/rooms/:id/settings/alarm", updateAlarmSetting)
	chat.Put("/rooms/:id/settings/screenshot", updateScreenshotSetting)

	// 메시지 관련 엔드포인트
	chat.Post("/messages", createMessage)
	chat.Get("/rooms/:id/messages/:personaId", getChatRoomMessages)
	chat.Put("/messages/:id/delivered", markMessageDelivered)

	// TODO: WebSocket 구현은 별도 파일(chat_ws.go)에서 구현 예정
}

// 채팅방 생성
func createChatRoom(c fiber.Ctx) error {
	var input struct {
		CreateBy   string   `json:"create_by"`
		PersonaIds []string `json:"persona_ids"`
	}

	if err := c.Bind().Body(&input); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Invalid input",
		})
	}

	// 채팅방 생성
	chatRoom := model.ChatRoom{
		CreateBy: input.CreateBy,
	}

	tx := config.ChatDB.Begin()
	if err := tx.Create(&chatRoom).Error; err != nil {
		tx.Rollback()
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Failed to create chat room",
		})
	}

	// 생성자를 참가자로 추가
	creatorData := model.ChatRoomPreference{
		ChatRoomID: chatRoom.ID,
		PersonaID:  input.CreateBy,
	}
	if err := tx.Create(&creatorData).Error; err != nil {
		tx.Rollback()
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Failed to add creator to chat room",
		})
	}

	// 추가 참가자들 추가
	for _, personaID := range input.PersonaIds {
		if personaID == input.CreateBy {
			continue // 생성자는 이미 추가됨
		}

		participantData := model.ChatRoomPreference{
			ChatRoomID: chatRoom.ID,
			PersonaID:  personaID,
		}
		if err := tx.Create(&participantData).Error; err != nil {
			tx.Rollback()
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"error": "Failed to add participants to chat room",
			})
		}
	}

	if err := tx.Commit().Error; err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Transaction failed",
		})
	}

	return c.Status(fiber.StatusCreated).JSON(fiber.Map{
		"message": "Chat room created successfully",
		"data":    chatRoom,
	})
}

// 특정 persona의 모든 채팅방 조회
func listPersonaChatRooms(c fiber.Ctx) error {
	myPersonaID := c.Params("myPersonaId")

	var chatRooms []model.ChatRoom
	err := config.ChatDB.Joins("JOIN chat_room_preference crd ON chat_room.id = crd.chat_room_id").
		Where("crd.persona_id = ?", myPersonaID).
		Preload("LastMessage").
		Preload("Participants.PersonaProfile").
		Find(&chatRooms).Error

	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"message": "Failed to get chat rooms",
		})
	}

	return c.JSON(fiber.Map{
		"message": "Chat rooms retrieved successfully",
		"data":    chatRooms,
	})
}

// 특정 persona의 채팅방 조회 (없으면 생성)
func getOrCreatePersonaChatRoom(c fiber.Ctx) error {
	myPersonaID := c.Params("myPersonaId")
	targetPersonaID := c.Params("targetPersonaId")

	// 같은 페르소나 ID를 사용하는 경우 방지
	if myPersonaID == targetPersonaID {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"message": "Cannot create chat room with same persona ID",
		})
	}

	var chatRoom model.ChatRoom
	err := config.ChatDB.Joins("JOIN chat_room_preference crd1 ON chat_room.id = crd1.chat_room_id").
		Joins("JOIN chat_room_preference crd2 ON chat_room.id = crd2.chat_room_id").
		Where("crd1.persona_id = ? AND crd2.persona_id = ?", myPersonaID, targetPersonaID).
		Where("(SELECT COUNT(*) FROM chat_room_preference WHERE chat_room_id = chat_room.id) = 2").
		Preload("LastMessage").
		Preload("Participants.PersonaProfile").
		First(&chatRoom).Error

	if err == nil {
		return c.JSON(fiber.Map{
			"message": "Chat room retrieved successfully",
			"data":    chatRoom,
		})
	}

	// 채팅방이 없으면 생성
	tx := config.ChatDB.Begin()

	chatRoom = model.ChatRoom{
		CreateBy: myPersonaID,
	}
	if err := tx.Create(&chatRoom).Error; err != nil {
		tx.Rollback()
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"message": "Failed to create chat room",
		})
	}

	// 참가자 추가 (순서대로 처리)
	participants := []model.ChatRoomPreference{
		{
			ChatRoomID: chatRoom.ID,
			PersonaID:  myPersonaID,
		},
		{
			ChatRoomID: chatRoom.ID,
			PersonaID:  targetPersonaID,
		},
	}

	for _, participant := range participants {
		if err := tx.Create(&participant).Error; err != nil {
			tx.Rollback()
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"message": "Failed to add participant to chat room",
			})
		}
	}

	if err := tx.Commit().Error; err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"message": "Transaction failed",
		})
	}

	// 생성된 채팅방 다시 조회하여 Participants 포함
	if err := config.ChatDB.Preload("LastMessage").Preload("Participants.PersonaProfile").First(&chatRoom, "id = ?", chatRoom.ID).Error; err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"message": "Failed to retrieve created chat room",
		})
	}

	return c.Status(fiber.StatusCreated).JSON(fiber.Map{
		"message": "Chat room created successfully",
		"data":    chatRoom,
	})
}

// 특정 채팅방 조회
func getChatRoom(c fiber.Ctx) error {
	roomID := c.Params("id")

	var chatRoom model.ChatRoom
	err := config.ChatDB.Preload("LastMessage").Preload("Participants.PersonaProfile").First(&chatRoom, "id = ?", roomID).Error

	if err != nil {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error": "Chat room not found",
		})
	}

	return c.JSON(fiber.Map{
		"message": "Chat room retrieved successfully",
		"data":    chatRoom,
	})
}

// 채팅방 삭제
func deleteChatRoom(c fiber.Ctx) error {
	roomID := c.Params("id")

	if err := config.ChatDB.Delete(&model.ChatRoom{}, "id = ?", roomID).Error; err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Failed to delete chat room",
		})
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"message": "Chat room deleted successfully",
	})
}

// 채팅방 참가자 추가
func addChatRoomParticipant(c fiber.Ctx) error {
	roomID := c.Params("id")
	
	var input struct {
		PersonaID string `json:"persona_id"`
	}

	if err := c.Bind().Body(&input); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Invalid input",
		})
	}

	data := model.ChatRoomPreference{
		ChatRoomID: roomID,
		PersonaID:  input.PersonaID,
	}

	if err := config.ChatDB.Create(&data).Error; err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Failed to add participant",
		})
	}

	return c.Status(fiber.StatusCreated).JSON(fiber.Map{
		"message": "Participant added successfully",
		"data":    data,
	})
}

// 채팅방 참가자 제거
func removeChatRoomParticipant(c fiber.Ctx) error {
	roomID := c.Params("id")
	personaID := c.Params("personaId")

	if err := config.ChatDB.Delete(&model.ChatRoomPreference{}, "chat_room_id = ? AND persona_id = ?", roomID, personaID).Error; err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Failed to remove participant",
		})
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"message": "Participant removed successfully",
	})
}

// 채팅방 참가자 목록 조회
func getChatRoomParticipants(c fiber.Ctx) error {
	roomID := c.Params("id")

	var participants []model.ChatRoomPreference
	if err := config.ChatDB.Where("chat_room_id = ?", roomID).Find(&participants).Error; err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Failed to get participants",
		})
	}

	return c.JSON(fiber.Map{
		"message": "Participants retrieved successfully",
		"data":    participants,
	})
}

// 알람 설정 변경
func updateAlarmSetting(c fiber.Ctx) error {
	roomID := c.Params("id")

	var input struct {
		PersonaID string `json:"persona_id"`
		Enabled   bool   `json:"enabled"`
	}

	if err := c.Bind().Body(&input); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Invalid input",
		})
	}

	if err := config.ChatDB.Model(&model.ChatRoomPreference{}).
		Where("chat_room_id = ? AND persona_id = ?", roomID, input.PersonaID).
		Update("alarm_enabled", input.Enabled).Error; err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Failed to update alarm setting",
		})
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"message": "Alarm setting updated successfully",
	})
}

// 스크린샷 설정 변경
func updateScreenshotSetting(c fiber.Ctx) error {
	roomID := c.Params("id")

	var input struct {
		PersonaID string `json:"persona_id"`
		Approved  bool   `json:"approved"`
	}

	if err := c.Bind().Body(&input); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Invalid input",
		})
	}

	if err := config.ChatDB.Model(&model.ChatRoomPreference{}).
		Where("chat_room_id = ? AND persona_id = ?", roomID, input.PersonaID).
		Update("screenshot_approved", input.Approved).Error; err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Failed to update screenshot setting",
		})
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"message": "Screenshot setting updated successfully",
	})
}

// 메시지 생성
func createMessage(c fiber.Ctx) error {
	var message model.Message

	// 요청 바디 로깅
	body := c.Body()
	// println("Received message body:", string(body))

	if err := json.Unmarshal(body, &message); err != nil {
		println("Binding error:", err.Error())
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"message": "Invalid input: " + err.Error(),
		})
	}

	// 메시지 구조 검증
	messageJSON, _ := json.Marshal(message)
	println("Message after binding:", string(messageJSON))

	// 필수 필드 검증
	if message.ChatRoomID == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"message": "ChatRoomID is required",
		})
	}
	if message.SenderID == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"message": "SenderID is required",
		})
	}

	// 채팅방 존재 여부 확인
	var chatRoom model.ChatRoom
	if err := config.ChatDB.First(&chatRoom, "id = ?", message.ChatRoomID).Error; err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"message": "Chat room not found",
		})
	}

	// 메시지 생성
	err := config.ChatDB.Transaction(func(tx *gorm.DB) error {
		// 메시지 생성
		if err := tx.Create(&message).Error; err != nil {
			return err
		}

		// 채팅방의 LastMessageID 업데이트
		if err := tx.Model(&model.ChatRoom{}).
			Where("id = ?", message.ChatRoomID).
			Update("last_message_id", message.ID).Error; err != nil {
			return err
		}

		return nil
	})

	if err != nil {
		println("Transaction error:", err.Error())
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"message": "Failed to create message: " + err.Error(),
		})
	}

	// 채팅방의 LastMessageID 업데이트
	if err := config.ChatDB.Model(&model.ChatRoom{}).
		Where("id = ?", message.ChatRoomID).
		Update("last_message_id", message.ID).Error; err != nil {
		println("Update last message error:", err.Error())
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"message": "Failed to update last message: " + err.Error(),
		})
	}

	// 수신자들에게 메시지 알림 전송 (비동기)
	go func() {
		// 필요한 필드만 선택적으로 쿼리
		var personaProfile struct {
			DisplayName     string `json:"display_name"`
			ProfileImageUrl string `json:"profile_image_url"`
		}

		if err := config.ChatDB.Model(&model.PersonaProfile{}).
			Select("display_name", "profile_image_url").
			Where("persona_id = ?", message.SenderID).
			First(&personaProfile).Error; err != nil {
			println("Failed to get sender profile:", err.Error())
			return
		}

		for _, receiverID := range message.ReceiverIDs {
			// 메시지 발신자에게는 알림을 보내지 않음
			if receiverID == message.SenderID {
				continue
			}

			// 메시지 요약 생성
			summary := createMessageSummary(message)
			summaryJSON, _ := json.Marshal(summary)

			// 알림 데이터 준비
			notificationData := map[string]interface{}{
				"to":     receiverID,
				"data":   string(summaryJSON),
				"action": model.ActionOpenChat,
			}

			// 메시지 내용 준비
			content := "새 메시지가 도착했습니다."
			if message.TextContent != nil && message.TextContent.Text != "" {
				content = message.TextContent.Text
			} else if message.MediaContent != nil {
				content = "미디어 메시지가 도착했습니다."
			}

			// 페르소나에 알림 전송
			if err := utils.SendPersonaNotification(config.DB, receiverID, utils.NotificationPayload{
				Type:    model.NotificationTypeMessage,
				Title:   personaProfile.DisplayName,
				Content: content,
				Icon:    personaProfile.ProfileImageUrl,
				Data:    notificationData,
			}); err != nil {
				println("Failed to send notification to persona", receiverID, ":", err.Error())
			}
		}
	}()

	return c.Status(fiber.StatusCreated).JSON(fiber.Map{
		"message": "Message created successfully",
		"data":    message,
	})
}

// 추가: 메시지를 요약하여 알림용으로 변환
func createMessageSummary(msg model.Message) NotificationSummaryMessage {
	summary := NotificationSummaryMessage{
		ID:         msg.ID,
		ChatRoomID: msg.ChatRoomID,
		SenderID:   msg.SenderID,
	}

	// 텍스트 내용 요약
	if msg.TextContent != nil && msg.TextContent.Text != "" {
		if len(msg.TextContent.Text) > maxFCMTextLength {
			summary.TextSummary = msg.TextContent.Text[:maxFCMTextLength-3] + "..."
		} else {
			summary.TextSummary = msg.TextContent.Text
		}
	}

	// 미디어 내용 요약
	if len(msg.MediaContent) > 0 {
		summary.HasMedia = true

		// 미디어 URL 추출 및 제한
		mediaURLs := make([]string, 0, min(len(msg.MediaContent), maxFCMMediaURLCount))
		for i, media := range msg.MediaContent {
			if i >= maxFCMMediaURLCount {
				break // 최대 URL 개수 제한
			}
			mediaURLs = append(mediaURLs, media.URL)
		}
		summary.MediaURLs = mediaURLs
	}

	return summary
}

// 채팅방 메시지 조회
func getChatRoomMessages(c fiber.Ctx) error {
	roomID := c.Params("id")
	personaID := c.Params("personaId")

	var messages []model.Message
	if err := config.ChatDB.Where("chat_room_id = ? AND ? = ANY(receiver_ids)", roomID, personaID).
		Order("created_at DESC").
		Find(&messages).Error; err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Failed to get messages",
		})
	}

	// Remove personaID from receiver_ids for each message
	tx := config.ChatDB.Begin()
	for i := range messages {
		// Filter out the current personaID from receiver_ids
		newReceiverIDs := make([]string, 0)
		for _, id := range messages[i].ReceiverIDs {
			if id != personaID {
				newReceiverIDs = append(newReceiverIDs, id)
			}
		}

		// receiver_ids 업데이트
		if err := tx.Model(&messages[i]).Update("receiver_ids", newReceiverIDs).Error; err != nil {
			tx.Rollback()
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"error": "Failed to update message receiver_ids",
			})
		}
		messages[i].ReceiverIDs = newReceiverIDs
	}

	if err := tx.Commit().Error; err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Failed to commit transaction",
		})
	}

	// receiver_ids가 비어있는 메시지들을 별도로 정리
	go func() {
		if err := config.ChatDB.Where("chat_room_id = ? AND receiver_ids IS NULL", roomID).
			Delete(&model.Message{}).Error; err != nil {
			println("Failed to clean up messages with empty receiver_ids:", err.Error())
		}
	}()

	return c.JSON(fiber.Map{
		"message": "Messages retrieved successfully",
		"data":    messages,
	})
}

// 메시지 배달 표시
func markMessageDelivered(c fiber.Ctx) error {
	messageID := c.Params("id")

	if err := config.ChatDB.Model(&model.Message{}).
		Where("id = ?", messageID).
		Update("is_delivered", true).Error; err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Failed to mark message as delivered",
		})
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"message": "Message marked as delivered successfully",
	})
}
