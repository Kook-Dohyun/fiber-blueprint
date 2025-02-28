package utils

import (
	"encoding/json"
	"fiber_server/model"
	"time"

	"firebase.google.com/go/messaging"
	"gorm.io/gorm"
)

// NotificationPayload : 알림 페이로드 구조체
type NotificationPayload struct {
	Type      model.NotificationType `json:"type"`
	Title     string                 `json:"title"`
	Content   string                 `json:"content"`
	Icon      string                 `json:"icon,omitempty"`
	Data      map[string]interface{} `json:"data,omitempty"`
	ExpiresAt *time.Time             `json:"expires_at,omitempty"`
}

// 최대 콘텐츠 길이 (FCM 제한에 맞춤, 실제 페이로드 크기는 더 작아야 함)
const maxContentLength = 300

// trimContent : 콘텐츠 길이가 최대 길이를 초과하면 자름
func trimContent(content string) string {
	if len(content) > maxContentLength {
		return content[:maxContentLength-3] + "..."
	}
	return content
}

// isWithinQuietHours : 현재 시간이 조용한 시간인지 확인
func isWithinQuietHours(quietHours model.QuietHoursSettings, currentTime time.Time) bool {
	if !quietHours.Enabled {
		return false
	}

	// 현재 시간을 TimeString 형식으로 변환
	currentTimeStr := model.TimeString(currentTime.Format(model.TimeFormatTimeOnly))

	// 시작 시간과 종료 시간이 같은 날인 경우
	if quietHours.StartTime <= quietHours.EndTime {
		return currentTimeStr >= quietHours.StartTime && currentTimeStr <= quietHours.EndTime
	}

	// 시작 시간과 종료 시간이 다른 날인 경우 (예: 22:00 ~ 07:00)
	return currentTimeStr >= quietHours.StartTime || currentTimeStr <= quietHours.EndTime
}

// isTransientNotificationType : DB에 저장하지 않을 알림 타입인지 확인
func isTransientNotificationType(notificationType model.NotificationType) bool {
	transientTypes := []model.NotificationType{
		model.NotificationTypeMessage,
		// model.NotificationTypeChat,
		// model.NotificationTypeCall,
		// model.NotificationTypeTransaction ,
		// model.NotificationTypePost        ,
		// model.NotificationTypeComment     ,
		// model.NotificationTypeLike        ,
		// model.NotificationTypeFollow      ,
		// model.NotificationTypeMention     ,
		// model.NotificationTypeSystem      ,
		// model.NotificationTypeProposal    ,
		// model.NotificationTypeDAO         ,
		// model.NotificationTypeVote  ,
	}

	for _, t := range transientTypes {
		if t == notificationType {
			return true
		}
	}

	return false
}

// SendDIDNotification : DID에 알림 전송
func SendDIDNotification(db *gorm.DB, did string, payload NotificationPayload) error {
	var preferences []model.NotificationPreference
	if err := db.Where("wallet_did = ?", did).Find(&preferences).Error; err != nil {
		return err
	}

	if len(preferences) == 0 {
		return nil
	}

	var fcmTokens []string

	for _, preference := range preferences {
		if !preference.IsEnabled {
			continue
		}

		// 조용한 시간 확인
		if isWithinQuietHours(preference.GlobalSettings.QuietHours, time.Now()) {
			isException := false
			for _, exception := range preference.GlobalSettings.QuietHours.Exceptions {
				if exception == payload.Type {
					isException = true
					break
				}
			}
			if !isException {
				continue
			}
		}

		// 알림 타입별 전송 여부
		settings, ok := preference.GlobalSettings.NotificationTypes[payload.Type]
		if !ok || !settings.Enabled {
			continue
		}

		// 일시적인 알림 타입이 아닌 경우에만 DB에 저장
		if !isTransientNotificationType(payload.Type) {
			// ✅ 루프 안에서 notification 생성
			expiresAt := payload.ExpiresAt
			if expiresAt == nil {
				expiresAt = model.GetDefaultExpirationTime(payload.Type)
			}

			notification := model.GlobalNotification{
				WalletDID: did,
				Type:      string(payload.Type),
				Title:     payload.Title,
				Content:   payload.Content,
				Data:      payload.Data,
				Priority:  getPriorityValue(settings.Priority),
				ExpiresAt: expiresAt,
			}

			if err := db.Create(&notification).Error; err != nil {
				return err // 실패 시 중단 (원하는 동작에 따라 무시할 수도 있음)
			}
		}

		// ✅ FCM 토큰 수집
		if preference.FCMToken != "" {
			fcmTokens = append(fcmTokens, preference.FCMToken)
		}
	}

	// ✅ 비동기 푸시 알림 발송
	if len(fcmTokens) > 0 {
		// FCM 메시지 구성
		message := &messaging.MulticastMessage{
			Tokens: fcmTokens,
			Notification: &messaging.Notification{
				Title:    payload.Title,
				Body:     trimContent(payload.Content),
				ImageURL: payload.Icon,
			},
			Data: map[string]string{
				"type":    string(payload.Type),
				"payload": marshalPayloadData(payload.Data),
			},
		}

		// 이미지 URL 확인
		imageURL := extractImageURL(payload.Data)
		if imageURL != "" {
			SendMulticastMessageWithImageAsync(message, imageURL)
		} else {
			SendMulticastMessageAsync(message)
		}
	}

	return nil
}

// SendPersonaNotification : Persona에 알림 전송
func SendPersonaNotification(db *gorm.DB, personaID string, payload NotificationPayload) error {
	var preference model.PersonaNotificationPreference

	// 1. 먼저 PersonaNotificationPreference를 로드
	if err := db.Where("persona_id = ?", personaID).First(&preference).Error; err != nil {
		return err
	}

	// 2. 연관된 NotificationPreference 수동으로 로드
	var notificationPref model.NotificationPreference
	if err := db.Where("id = ?", preference.PreferenceID).First(&notificationPref).Error; err != nil {
		return err
	}

	preference.Preference = &notificationPref

	if !preference.IsEnabled {
		return nil
	}

	// 조용한 시간 확인
	if isWithinQuietHours(preference.PersonaSettings.QuietHours, time.Now()) {
		// 조용한 시간 예외 처리
		isException := false
		for _, exception := range preference.PersonaSettings.QuietHours.Exceptions {
			if exception == payload.Type {
				isException = true
				break
			}
		}
		if !isException {
			return nil
		}
	}

	// 알림 타입 설정 확인 (변경된 부분)
	priority := model.NotificationPriorityNormal

	// 타입 설정이 있는 경우만 해당 설정을 확인
	if settings, ok := preference.PersonaSettings.NotificationTypes[payload.Type]; ok {
		if !settings.Enabled {
			return nil
		}
		priority = settings.Priority
	}

	// 일시적인 알림 타입이 아닌 경우에만 DB에 저장
	if !isTransientNotificationType(payload.Type) {
		expiresAt := payload.ExpiresAt
		if expiresAt == nil {
			expiresAt = model.GetDefaultExpirationTime(payload.Type)
		}

		// 알림 생성
		notification := model.PersonaNotification{
			PersonaID: personaID,
			Type:      string(payload.Type),
			Title:     payload.Title,
			Content:   payload.Content,
			Data:      payload.Data,
			Priority:  getPriorityValue(priority),
			ExpiresAt: expiresAt,
		}

		if err := db.Create(&notification).Error; err != nil {
			return err
		}
	}

	// FCM 토큰이 있는 경우 푸시 알림 전송
	if preference.Preference.FCMToken != "" {
		// FCM 메시지 구성
		message := &messaging.Message{

			Token: preference.Preference.FCMToken,
			Notification: &messaging.Notification{
				Title: payload.Title,
				Body:  trimContent(payload.Content),
				// Icon URL 추가
				ImageURL: payload.Icon,
			},
			Data: map[string]string{
				"type":    string(payload.Type),
				"payload": marshalPayloadData(payload.Data),
			},
		}

		// 이미지가 별도로 있는 경우에만 이미지 메시지로 전송
		imageURL := extractImageURL(payload.Data)
		if imageURL != "" {
			SendMessageWithImageAsync(message, imageURL)
		} else {
			SendMessageAsync(message)
		}
	}

	return nil
}

// getPriorityValue : 우선순위 문자열을 숫자로 변환
func getPriorityValue(priority model.NotificationPriority) int {
	switch priority {
	case model.NotificationPriorityHigh:
		return 1
	case model.NotificationPriorityLow:
		return -1
	default:
		return 0
	}
}

// extractImageURL : 페이로드 데이터에서 이미지 URL 추출
func extractImageURL(data map[string]interface{}) string {
	// 이미지 URL 확인 로직
	if data == nil {
		return ""
	}

	// 이미지 URL이 포함된 키 검색 (키는 실제 구현에 맞게 조정 필요)
	if imageURL, ok := data["image_url"].(string); ok && imageURL != "" {
		return imageURL
	}

	if imageURL, ok := data["imageUrl"].(string); ok && imageURL != "" {
		return imageURL
	}

	if media, ok := data["media"].(map[string]interface{}); ok {
		if url, ok := media["url"].(string); ok {
			return url
		}
	}

	return ""
}

// marshalPayloadData : 페이로드 데이터를 문자열로 변환
func marshalPayloadData(data map[string]interface{}) string {
	if data == nil {
		return "{}"
	}

	jsonData, err := json.Marshal(data)
	if err != nil {
		return "{}"
	}

	return string(jsonData)
}
