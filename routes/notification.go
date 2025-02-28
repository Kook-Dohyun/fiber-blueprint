package routes

import (
	"encoding/json"
	"errors"
	"fiber_server/config"
	"fiber_server/model"
	"fiber_server/routes/middleware/authority"
	"fiber_server/utils"
	"time"

	"github.com/gofiber/fiber/v3"
	"gorm.io/gorm"
)

// SetupNotificationRoutes : 알림 관련 라우트 설정
func SetupNotificationRoutes(app *fiber.App) {
	notificationGroup := app.Group("/notification")

	// Wallet 레벨 알림 설정
	notificationGroup.Get("/preferences", getNotificationPreferences)
	notificationGroup.Put("/preferences", updateNotificationPreferences)

	// Persona 레벨 알림 설정
	notificationGroup.Get("/persona-preferences", getPersonaNotificationPreferences)
	notificationGroup.Put("/persona-preferences", updatePersonaNotificationPreferences)

	// 알림 전송
	notificationGroup.Post("/send", sendNotification)
}

// getNotificationPreferences : Wallet의 알림 설정 조회
func getNotificationPreferences(c fiber.Ctx) error {
	did, err := authority.ExtractBaererHeader(c)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "DID is required",
		})
	}

	fcmToken := c.Query("fcm_token")
	if fcmToken == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "fcm_token is required",
		})
	}

	var preference model.NotificationPreference
	if err := config.DB.
		Preload("PersonaPreferences").
		Where("wallet_did = ?", did).First(&preference).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			// 기본 설정 생성
			defaultSettings := model.NotificationGlobalSettings{
				NotificationTypes: model.NotificationTypes{

					model.NotificationTypeSystem: model.NotificationTypeSettings{
						Enabled:  true,
						Sound:    model.NotificationSoundSystem,
						Priority: model.NotificationPriorityHigh,
					},
				},
				QuietHours: model.QuietHoursSettings{
					Enabled:    false,
					StartTime:  model.TimeString("22:00"),
					EndTime:    model.TimeString("07:00"),
					Exceptions: []model.NotificationType{model.NotificationTypeMessage, model.NotificationTypeSystem},
				},
				Grouping: model.NotificationGrouping{
					Enabled:  true,
					GroupBy:  "type",
					Collapse: true,
				},
			}

			preference = model.NotificationPreference{
				WalletDID:      did,
				FCMToken:       fcmToken,
				IsEnabled:      true,
				GlobalSettings: defaultSettings,
			}

			if err := config.DB.Create(&preference).Error; err != nil {
				return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
					"error": "failed to create default notification preferences",
				})
			}

			// 생성 후 다시 Preload하여 조회
			if err := config.DB.
				Preload("PersonaPreferences").
				Preload("Wallet").
				Where("wallet_did = ?", did).First(&preference).Error; err != nil {
				return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
					"error": "failed to fetch created notification preferences",
				})
			}
		} else {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"error": "failed to fetch notification preferences",
			})
		}
	} else {
		// FCM 토큰 업데이트
		if err := config.DB.Select("fcm_token").Model(&preference).Update("fcm_token", fcmToken).Error; err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"error": "failed to update FCM token",
			})
		}
	}

	return c.JSON(fiber.Map{
		"message": "notification preferences retrieved successfully",
		"data":    preference,
	})
}

// updateNotificationPreferences : Wallet의 알림 설정 업데이트
func updateNotificationPreferences(c fiber.Ctx) error {
	did, err := authority.ExtractBaererHeader(c)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "DID is required",
		})
	}

	var input struct {
		FCMToken       *string                           `json:"fcm_token,omitempty"`
		IsEnabled      *bool                             `json:"is_enabled,omitempty"`
		GlobalSettings *model.NotificationGlobalSettings `json:"global_settings,omitempty"`
	}

	if err := json.Unmarshal(c.Body(), &input); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "invalid request body",
		})
	}

	// 트랜잭션 시작
	err = config.DB.Transaction(func(tx *gorm.DB) error {
		var preference model.NotificationPreference
		if err := tx.Where("wallet_did = ?", did).First(&preference).Error; err != nil {
			if errors.Is(err, gorm.ErrRecordNotFound) {
				return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
					"error": "notification preferences not found",
				})
			}
			return err
		}

		// 업데이트할 필드만 포함
		updates := make(map[string]interface{})
		if input.FCMToken != nil {
			updates["fcm_token"] = *input.FCMToken
		}
		if input.IsEnabled != nil {
			updates["is_enabled"] = *input.IsEnabled
		}
		if input.GlobalSettings != nil {
			updates["global_settings"] = *input.GlobalSettings
		}
		updates["updated_at"] = time.Now()

		if len(updates) == 0 {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
				"error": "no fields to update",
			})
		}

		return tx.Model(&preference).Updates(updates).Error
	})

	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "failed to update notification preferences",
		})
	}

	return c.JSON(fiber.Map{
		"message": "notification preferences updated successfully",
	})
}

// getPersonaNotificationPreferences : Persona의 알림 설정 조회
func getPersonaNotificationPreferences(c fiber.Ctx) error {
	did, err := authority.ExtractBaererHeader(c)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "DID is required",
		})
	}

	personaID := c.Query("persona_id")
	if personaID == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "persona_id is required",
		})
	}

	// 1. 기존 설정 조회
	var preference model.PersonaNotificationPreference
	err = config.DB.
		Where("persona_id = ?", personaID).
		First(&preference).Error

	// 2. 설정이 없는 경우에만 기본 설정 생성
	if errors.Is(err, gorm.ErrRecordNotFound) {
		// Wallet의 NotificationPreference 조회
		var walletPref model.NotificationPreference
		if err := config.DB.Where("wallet_did = ?", did).First(&walletPref).Error; err != nil {
			return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
				"error": "wallet notification preferences not found",
			})
		}

		// 모든 알림 타입에 대한 기본 설정 생성
		defaultNotificationTypes := make(model.NotificationTypes)

		// 기본 알림 타입들에 대한 설정
		defaultTypesWithSettings := map[model.NotificationType]model.NotificationTypeSettings{
			model.NotificationTypePost: {
				Enabled:  true,
				Sound:    model.NotificationSoundDefault,
				Priority: model.NotificationPriorityHigh,
			},
			model.NotificationTypeComment: {
				Enabled:  true,
				Sound:    model.NotificationSoundDefault,
				Priority: model.NotificationPriorityNormal,
			},
			model.NotificationTypeMessage: {
				Enabled:  true,
				Sound:    model.NotificationSoundMessage,
				Priority: model.NotificationPriorityHigh,
			},
			model.NotificationTypeSystem: {
				Enabled:  true,
				Sound:    model.NotificationSoundSystem,
				Priority: model.NotificationPriorityHigh,
			},
			model.NotificationTypeChat: {
				Enabled:  true,
				Sound:    model.NotificationSoundMessage,
				Priority: model.NotificationPriorityNormal,
			},
			// 여기에 추가 타입 설정 가능
		}

		// 알려진 모든 알림 타입에 대해 기본 설정 적용
		for notificationType, settings := range defaultTypesWithSettings {
			defaultNotificationTypes[notificationType] = settings
		}

		// 기본 설정에 없는 알림 타입도 기본값으로 추가
		allKnownTypes := getPersonaNotificationTypes()
		for _, typeName := range allKnownTypes {
			if _, exists := defaultNotificationTypes[typeName]; !exists {
				// 기본 설정이 없는 타입에는 표준 기본값 적용
				defaultNotificationTypes[typeName] = model.NotificationTypeSettings{
					Enabled:  true,
					Sound:    model.NotificationSoundDefault,
					Priority: model.NotificationPriorityNormal,
				}
			}
		}

		defaultSettings := model.NotificationPersonaSettings{
			NotificationTypes: defaultNotificationTypes,
			QuietHours: model.QuietHoursSettings{
				Enabled:    false,
				StartTime:  model.TimeString("22:00"),
				EndTime:    model.TimeString("07:00"),
				Exceptions: []model.NotificationType{model.NotificationTypeMessage, model.NotificationTypeSystem},
			},
			Grouping: model.NotificationGrouping{
				Enabled:  true,
				GroupBy:  "type",
				Collapse: true,
			},
		}

		preference = model.PersonaNotificationPreference{
			PreferenceID:    walletPref.ID,
			PersonaID:       personaID,
			IsEnabled:       true,
			PersonaSettings: defaultSettings,
		}

		if err := config.DB.Select("preference_id", "persona_id", "is_enabled", "persona_settings").Create(&preference).Error; err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"error": "failed to create default persona notification preferences",
			})
		}
	} else if err != nil {
		// 조회 중 다른 에러가 발생한 경우
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "failed to fetch persona notification preferences",
		})
	}

	return c.JSON(fiber.Map{
		"message": "persona notification preferences retrieved successfully",
		"data":    preference,
	})
}

// getPersonaNotificationTypes : 모든 알림 타입 목록 반환
func getPersonaNotificationTypes() []model.NotificationType {
	return []model.NotificationType{
		model.NotificationTypePost,
		model.NotificationTypeComment,
		model.NotificationTypeMessage,
		model.NotificationTypeChat,
		model.NotificationTypeLike,
		model.NotificationTypeFollow,
		model.NotificationTypeCall,
		model.NotificationTypeDAO,
		model.NotificationTypeMention,
		model.NotificationTypeProposal,
		model.NotificationTypeVote,
		model.NotificationTypeTransaction,
		// 여기에 새로운 알림 타입을 추가할 수 있습니다
	}
}

// updatePersonaNotificationPreferences : Persona의 알림 설정 업데이트
func updatePersonaNotificationPreferences(c fiber.Ctx) error {
	_, err := authority.ExtractBaererHeader(c)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "DID is required",
		})
	}

	var input struct {
		PersonaID       string                             `json:"persona_id"`
		IsEnabled       *bool                              `json:"is_enabled,omitempty"`
		PersonaSettings *model.NotificationPersonaSettings `json:"persona_settings,omitempty"`
	}

	if err := json.Unmarshal(c.Body(), &input); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "invalid request body",
		})
	}

	// 트랜잭션 시작
	err = config.DB.Transaction(func(tx *gorm.DB) error {
		var preference model.PersonaNotificationPreference
		if err := tx.Where("persona_id = ?", input.PersonaID).First(&preference).Error; err != nil {
			if errors.Is(err, gorm.ErrRecordNotFound) {
				return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
					"error": "persona notification preferences not found",
				})
			}
			return err
		}

		// 업데이트할 필드만 포함
		updates := make(map[string]interface{})
		if input.IsEnabled != nil {
			updates["is_enabled"] = *input.IsEnabled
		}
		if input.PersonaSettings != nil {
			updates["persona_settings"] = *input.PersonaSettings
		}
		updates["updated_at"] = time.Now()

		if len(updates) == 0 {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
				"error": "no fields to update",
			})
		}

		return tx.Model(&preference).Updates(updates).Error
	})

	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "failed to update persona notification preferences",
		})
	}

	return c.JSON(fiber.Map{
		"message": "persona notification preferences updated successfully",
	})
}

// sendNotification : 알림 전송
func sendNotification(c fiber.Ctx) error {
	_, err := authority.ExtractBaererHeader(c)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "DID is required",
		})
	}

	var input struct {
		Type    model.NotificationType `json:"type"`    // 알림 타입
		Title   string                 `json:"title"`   // 알림 제목
		Content string                 `json:"content"` // 알림 내용
		Data    map[string]interface{} `json:"data"`    // 추가 데이터
		To      struct {
			Type  string `json:"type"`  // "did" 또는 "persona"
			Value string `json:"value"` // 수신자 DID 또는 Persona ID
		} `json:"to"` // 수신자 정보
	}

	if err := json.Unmarshal(c.Body(), &input); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "invalid request body",
		})
	}

	// 수신자 정보가 없을 경우 에러 처리
	if input.To.Value == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "receiver information is required",
		})
	}

	payload := utils.NotificationPayload{
		Type:    input.Type,
		Title:   input.Title,
		Content: input.Content,
		Data:    input.Data,
	}

	var sendErr error
	if input.To.Type == "persona" {
		// Persona 알림 전송
		sendErr = utils.SendPersonaNotification(config.DB, input.To.Value, payload)
	} else if input.To.Type == "did" {
		// Wallet 알림 전송
		// sendErr = utils.SendDIDNotification(config.DB, input.To.Value, payload)
	} else {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "invalid receiver type",
		})
	}

	if sendErr != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "failed to send notification",
		})
	}

	return c.JSON(fiber.Map{
		"message": "notification sent successfully",
	})
}
