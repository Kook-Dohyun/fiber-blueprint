package routes

import (
	"encoding/json"
	"errors"
	"fiber_server/config"
	"fiber_server/model"

	"github.com/gofiber/fiber/v3"
	"gorm.io/gorm"
)

func SetupPersonaSubscribeRoutes(app *fiber.App) {
	subscribeGroup := app.Group("/subscribe")
	subscribeGroup.Post("/", createSubscription)
	subscribeGroup.Put("/", updateSubscription)
	subscribeGroup.Patch("/:id/status", updateSubscriptionStatus)
	subscribeGroup.Delete("/:id", cancelSubscription)
}

func createSubscription(c fiber.Ctx) error {
	var input struct {
		PersonaID    string `json:"persona_id"`
		SubscriberID string `json:"subscriber_id"`
	}

	if err := json.Unmarshal(c.Body(), &input); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "잘못된 요청 형식입니다",
		})
	}

	// 필수 필드 검증
	if input.PersonaID == "" || input.SubscriberID == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "persona_id와 subscriber_id는 필수입니다",
		})
	}

	// 이미 존재하는 구독인지 확인
	var existingSubscription model.PersonaSubscriber
	err := config.DB.Where("persona_id = ? AND subscriber_id = ?",
		input.PersonaID, input.SubscriberID).First(&existingSubscription).Error

	if err == nil {
		updateSubscription(c)
	}

	// 새 구독 생성 - 기본값 사용
	subscription := model.PersonaSubscriber{
		PersonaID:    input.PersonaID,
		SubscriberID: input.SubscriberID,
	}

	if err := config.DB.Create(&subscription).Error; err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "구독 생성에 실패했습니다",
		})
	}

	return c.Status(fiber.StatusCreated).JSON(fiber.Map{
		"message": "구독이 생성되었습니다",
		"data":    subscription,
	})
}

// updateSubscription : 구독 정보 전체 업데이트
func updateSubscription(c fiber.Ctx) error {
	var input struct {
		PersonaID    string `json:"persona_id"`
		SubscriberID string `json:"subscriber_id"`
		IsPaid       *bool  `json:"is_paid"`
		Status       string `json:"status"`
	}

	if err := json.Unmarshal(c.Body(), &input); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "잘못된 요청 형식입니다",
		})
	}

	var subscription model.PersonaSubscriber
	result := config.DB.Where("persona_id = ? AND subscriber_id = ?",
		input.PersonaID, input.SubscriberID).First(&subscription)

	if result.Error != nil {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error": "구독 정보를 찾을 수 없습니다",
		})
	}

	subscription.IsPaid = input.IsPaid
	if err := config.DB.Save(&subscription).Error; err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "구독 정보 업데이트에 실패했습니다",
		})
	}

	return c.JSON(fiber.Map{
		"message": "구독 정보가 업데이트되었습니다",
		"data":    subscription,
	})
}

// updateSubscriptionStatus : 구독 상태만 업데이트
func updateSubscriptionStatus(c fiber.Ctx) error {
	id := c.Params("id")
	var input struct {
		Status string `json:"status"`
	}

	if err := json.Unmarshal(c.Body(), &input); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "잘못된 요청 형식입니다",
		})
	}

	result := config.DB.Model(&model.PersonaSubscriber{}).
		Where("id = ?", id).
		Update("status", input.Status)

	if result.Error != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "구독 상태 업데이트에 실패했습니다",
		})
	}

	if result.RowsAffected == 0 {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error": "구독 정보를 찾을 수 없습니다",
		})
	}

	return c.JSON(fiber.Map{
		"message": "구독 상태가 업데이트되었습니다",
	})
}

// cancelSubscription : 구독 취소 (삭제)
func cancelSubscription(c fiber.Ctx) error {
	id := c.Params("id")
	if id == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "구독 ID가 필요합니다",
		})
	}

	var subscription model.PersonaSubscriber

	// 트랜잭션 시작
	err := config.DB.Transaction(func(tx *gorm.DB) error {
		// 1. 구독 정보 조회
		if err := tx.First(&subscription, "id = ?", id).Error; err != nil {
			return err
		}

		// 2. 구독 삭제
		if err := tx.Delete(&subscription).Error; err != nil {
			return err
		}

		return nil
	})

	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
				"error": "구독 정보를 찾을 수 없습니다",
			})
		}
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "구독 취소에 실패했습니다",
		})
	}

	return c.JSON(fiber.Map{
		"message": "구독이 성공적으로 취소되었습니다",
		"data":    subscription,
	})
}
