package utils

import (
	"context"
	"fiber_server/config"
	"log"

	firebase "firebase.google.com/go"
	"firebase.google.com/go/messaging"
	"google.golang.org/api/option"
)

// FirebaseClient 전역 변수로 Firebase 클라이언트 선언
var FirebaseClient *messaging.Client

// InitFirebaseApp Firebase 앱을 초기화하고 전역 클라이언트 설정
func InitFirebaseApp() {
	ctx := context.Background()

	// Firebase 서비스 계정 키 JSON 파일 실제 경로
	opt := option.WithCredentialsFile(config.AppConfig.Firebase.CredentialsPath)

	app, err := firebase.NewApp(ctx, nil, opt)
	if err != nil {
		log.Fatalf("Firebase App 초기화 실패: %v", err)
	}

	client, err := app.Messaging(ctx)
	if err != nil {
		log.Fatalf("Firebase Messaging Client 초기화 실패: %v", err)
	}

	FirebaseClient = client
}

// SendMessageAsync : 미리 구성된 메시지 비동기 전송
func SendMessageAsync(message *messaging.Message) {
	go func() {
		result, err := FirebaseClient.Send(context.Background(), message)
		if err != nil {
			log.Printf("❌ FCM 메시지 전송 실패: 토큰=%s, 에러=%v", message.Token, err)
		} else {
			log.Printf("✅ FCM 메시지 전송 성공: 토큰=%s, 결과=%s", message.Token, result)
		}
	}()
}

// SendMessageWithImageAsync : 이미지가 포함된 미리 구성된 메시지 비동기 전송
func SendMessageWithImageAsync(message *messaging.Message, imageURL string) {
	go func() {
		// Android 설정
		message.Android = &messaging.AndroidConfig{
			Notification: &messaging.AndroidNotification{
				ImageURL: imageURL,
			},
		}

		// Apple 설정
		message.APNS = &messaging.APNSConfig{
			Payload: &messaging.APNSPayload{
				Aps: &messaging.Aps{
					MutableContent: true,
				},
			},
			FCMOptions: &messaging.APNSFCMOptions{
				ImageURL: imageURL,
			},
		}

		result, err := FirebaseClient.Send(context.Background(), message)
		if err != nil {
			log.Printf("❌ FCM 이미지 메시지 전송 실패: 토큰=%s, 이미지=%s, 에러=%v",
				message.Token, imageURL, err)
		} else {
			log.Printf("✅ FCM 이미지 메시지 전송 성공: 토큰=%s, 이미지=%s, 결과=%s",
				message.Token, imageURL, result)
		}
	}()
}

// SendMulticastMessageAsync : 미리 구성된 멀티캐스트 메시지 비동기 전송
func SendMulticastMessageAsync(message *messaging.MulticastMessage) {
	go func() {
		if len(message.Tokens) == 0 {
			return
		}

		response, err := FirebaseClient.SendMulticast(context.Background(), message)
		if err != nil {
			log.Printf("❌ FCM 멀티캐스트 메시지 전송 실패: 토큰 개수=%d, 에러=%v",
				len(message.Tokens), err)
		} else {
			log.Printf("✅ FCM 멀티캐스트 메시지 전송: 성공=%d, 실패=%d",
				response.SuccessCount, response.FailureCount)
			if response.FailureCount > 0 {
				for i, resp := range response.Responses {
					if !resp.Success {
						log.Printf("  - 실패 토큰: %s, 에러=%v", message.Tokens[i], resp.Error)
					}
				}
			}
		}
	}()
}

// SendMulticastMessageWithImageAsync : 이미지가 포함된 미리 구성된 멀티캐스트 메시지 비동기 전송
func SendMulticastMessageWithImageAsync(message *messaging.MulticastMessage, imageURL string) {
	go func() {
		if len(message.Tokens) == 0 {
			return
		}

		// Android 설정
		message.Android = &messaging.AndroidConfig{
			Notification: &messaging.AndroidNotification{
				ImageURL: imageURL,
			},
		}

		// Apple 설정
		message.APNS = &messaging.APNSConfig{
			Payload: &messaging.APNSPayload{
				Aps: &messaging.Aps{
					MutableContent: true,
				},
			},
			FCMOptions: &messaging.APNSFCMOptions{
				ImageURL: imageURL,
			},
		}

		response, err := FirebaseClient.SendMulticast(context.Background(), message)
		if err != nil {
			log.Printf("❌ FCM 멀티캐스트 이미지 메시지 전송 실패: 토큰 개수=%d, 이미지=%s, 에러=%v",
				len(message.Tokens), imageURL, err)
		} else {
			log.Printf("✅ FCM 멀티캐스트 이미지 메시지 전송: 성공=%d, 실패=%d",
				response.SuccessCount, response.FailureCount)
			if response.FailureCount > 0 {
				for i, resp := range response.Responses {
					if !resp.Success {
						log.Printf("  - 실패 토큰: %s, 에러=%v", message.Tokens[i], resp.Error)
					}
				}
			}
		}
	}()
}

// SendToSingleDeviceAsync : 단일 기기 비동기 메시지 전송
func SendToSingleDeviceAsync(token string, data map[string]string) {
	go func() {
		message := messaging.Message{
			Data:  data,
			Token: token,
		}

		result, err := FirebaseClient.Send(context.Background(), &message)
		if err != nil {
			log.Printf("❌ FCM 메시지 전송 실패: 토큰=%s, 에러=%v", token, err)
		} else {
			log.Printf("✅ FCM 메시지 전송 성공: 토큰=%s, 결과=%s", token, result)
		}
	}()
}

// SendToSingleDeviceWithImageAsync : 이미지가 포함된 단일 기기 메시지 전송
func SendToSingleDeviceWithImageAsync(token string, data map[string]string, imageURL string) {
	go func() {
		message := &messaging.Message{
			Data:  data,
			Token: token,
			// Android 설정
			Android: &messaging.AndroidConfig{
				Notification: &messaging.AndroidNotification{
					ImageURL: imageURL,
				},
			},
			// Apple 설정
			APNS: &messaging.APNSConfig{
				Payload: &messaging.APNSPayload{
					Aps: &messaging.Aps{
						MutableContent: true,
					},
				},
				FCMOptions: &messaging.APNSFCMOptions{
					ImageURL: imageURL,
				},
			},
		}

		result, err := FirebaseClient.Send(context.Background(), message)
		if err != nil {
			log.Printf("❌ FCM 이미지 메시지 전송 실패: 토큰=%s, 이미지=%s, 에러=%v", token, imageURL, err)
		} else {
			log.Printf("✅ FCM 이미지 메시지 전송 성공: 토큰=%s, 이미지=%s, 결과=%s", token, imageURL, result)
		}
	}()
}

// SendToMultipleDevicesAsync : 복수 기기 비동기 메시지 전송
func SendToMultipleDevicesAsync(tokens []string, data map[string]string) {
	go func() {
		if len(tokens) == 0 {
			return
		}

		message := &messaging.MulticastMessage{
			Data:   data,
			Tokens: tokens,
		}

		response, err := FirebaseClient.SendMulticast(context.Background(), message)
		if err != nil {
			log.Printf("❌ FCM 멀티캐스트 메시지 전송 실패: 토큰 개수=%d, 에러=%v", len(tokens), err)
		} else {
			log.Printf("✅ FCM 멀티캐스트 메시지 전송: 성공=%d, 실패=%d", response.SuccessCount, response.FailureCount)
			if response.FailureCount > 0 {
				for i, resp := range response.Responses {
					if !resp.Success {
						log.Printf("  - 실패 토큰: %s, 에러=%v", tokens[i], resp.Error)
					}
				}
			}
		}
	}()
}

// SendToMultipleDevicesWithImageAsync : 이미지가 포함된 복수 기기 메시지 전송
func SendToMultipleDevicesWithImageAsync(tokens []string, data map[string]string, imageURL string) {
	go func() {
		if len(tokens) == 0 {
			return
		}

		message := &messaging.MulticastMessage{
			Tokens: tokens,
			Data:   data,
			// Android 설정
			Android: &messaging.AndroidConfig{
				Notification: &messaging.AndroidNotification{
					ImageURL: imageURL,
				},
			},
			// Apple 설정
			APNS: &messaging.APNSConfig{
				Payload: &messaging.APNSPayload{
					Aps: &messaging.Aps{
						MutableContent: true,
					},
				},
				FCMOptions: &messaging.APNSFCMOptions{
					ImageURL: imageURL,
				},
			},
		}

		response, err := FirebaseClient.SendMulticast(context.Background(), message)
		if err != nil {
			log.Printf("❌ FCM 멀티캐스트 이미지 메시지 전송 실패: 토큰 개수=%d, 이미지=%s, 에러=%v", len(tokens), imageURL, err)
		} else {
			log.Printf("✅ FCM 멀티캐스트 이미지 메시지 전송: 성공=%d, 실패=%d", response.SuccessCount, response.FailureCount)
			if response.FailureCount > 0 {
				for i, resp := range response.Responses {
					if !resp.Success {
						log.Printf("  - 실패 토큰: %s, 에러=%v", tokens[i], resp.Error)
					}
				}
			}
		}
	}()
}

// SendToTopicAsync : 주제(topic) 기반 비동기 메시지 전송
func SendToTopicAsync(topic string, data map[string]string) {
	go func() {
		message := &messaging.Message{
			Data:  data,
			Topic: topic,
		}
		_, _ = FirebaseClient.Send(context.Background(), message)
	}()
}

// SendToConditionAsync : 조건 기반 비동기 메시지 전송
func SendToConditionAsync(condition string, data map[string]string) {
	go func() {
		message := &messaging.Message{
			Data:      data,
			Condition: condition,
		}
		_, _ = FirebaseClient.Send(context.Background(), message)
	}()
}

// SendToDeviceGroupAsync : 디바이스 그룹 기반 비동기 메시지 전송
// notificationKey 는 사전에 발급받은 그룹 키
func SendToDeviceGroupAsync(notificationKey string, data map[string]string) {
	go func() {
		message := &messaging.Message{
			Data:  data,
			Token: notificationKey,
		}
		_, _ = FirebaseClient.Send(context.Background(), message)
	}()
}
