package routes

import (
	"encoding/json"
	"fiber_server/config"
	"fiber_server/model"
	"fiber_server/routes/middleware/authority"
	"strings"

	"github.com/gofiber/fiber/v3"
	"gorm.io/gorm"
)

// SetupPersonaBackgroundMediaRoutes : /persona/profile/background 경로에 대한 CRUD 라우트 설정
func SetupPersonaBackgroundMediaRoutes(app *fiber.App) {
	bgMediaGroup := app.Group("/persona/profile/background")
	bgMediaGroup.Get("/:persona_id", getPersonaBackgroundMedia)
	bgMediaGroup.Post("/:persona_id", createPersonaBackgroundMedia)
	bgMediaGroup.Put("/:persona_id", updatePersonaBackgroundMedia)
	bgMediaGroup.Delete("/:persona_id", deletePersonaBackgroundMedia)
}

func getPersonaBackgroundMedia(c fiber.Ctx) error {
	// ✅ 1. 패스 파라미터에서 persona_id 가져오기
	personaID := c.Params("persona_id")
	if personaID == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "persona_id is required"})
	}

	// ✅ 2. 트랜잭션 시작 (persona_profile_id 조회 포함)
	var bgMedia model.PersonaBackgroundMedia
	err := config.DB.Transaction(func(tx *gorm.DB) error {
		// ✅ 2-1. persona_id 기반으로 persona_profile_id 조회 (1:1 관계)
		var personaProfileID string
		if err := tx.Table("persona_profile").
			Select("id").
			Where("persona_id = ?", personaID).
			Scan(&personaProfileID).Error; err != nil {
			return fiber.NewError(fiber.StatusNotFound, "persona profile not found")
		}

		// ✅ 2-2. 특정 필드만 조회 (fields 존재 시)
		fields := c.Query("fields")
		query := tx.Model(&model.PersonaBackgroundMedia{}).
			Where("persona_profile_id = ?", personaProfileID)

		if fields != "" {
			fieldList := strings.Split(fields, ",")
			query = query.Select(fieldList)
		}

		// ✅ 2-3. 조회 결과 저장
		if err := query.First(&bgMedia).Error; err != nil {
			return fiber.NewError(fiber.StatusNotFound, "background media not found")
		}

		return nil // 트랜잭션 커밋
	})

	// ✅ 3. 트랜잭션 에러 처리
	if err != nil {
		if fiberErr, ok := err.(*fiber.Error); ok {
			return c.Status(fiberErr.Code).JSON(fiber.Map{"error": fiberErr.Message})
		}
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "failed to retrieve background media"})
	}

	// ✅ 4. 성공 응답 반환 (GORM이 자동으로 `null` 필드 제거)
	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"message": "background media retrieved successfully",
		"data":    nil,
	})
}

func createPersonaBackgroundMedia(c fiber.Ctx) error {
	// ✅ 1. 요청 바디에서 media_url 파싱
	var input struct {
		MediaURL string `json:"media_url"`
	}
	if err := json.Unmarshal(c.Body(), &input); err != nil || input.MediaURL == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "media_url is required"})
	}

	// ✅ 2. 패스 파라미터에서 persona_id 가져오기
	personaID := c.Params("persona_id")
	if personaID == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "persona_id is required"})
	}

	// ✅ 3. 트랜잭션 시작
	var bgMedia model.PersonaBackgroundMedia
	err := config.DB.Transaction(func(tx *gorm.DB) error {
		// ✅ 3-1. 권한 검증 (미들웨어처럼 사용)
		if err := validatePersonaAccess(c, tx, personaID); err != nil {
			return err // 트랜잭션 자동 롤백됨
		}

		var personaProfileID string
		// ✅ 3-2. persona_id 기반으로 persona_profile_id 조회 (1:1 관계)
		if err := tx.Table("persona_profile").
			Select("id").
			Where("persona_id = ?", personaID).
			Scan(&personaProfileID).Error; err != nil {
			return fiber.NewError(fiber.StatusNotFound, "persona profile not found") // 트랜잭션 자동 롤백
		}

		// ✅ 3-3. 배경 미디어 레코드 생성
		bgMedia := &model.PersonaBackgroundMedia{
			PersonaProfileID: personaProfileID,
			MediaURL:         input.MediaURL,
		}
		if err := tx.Create(bgMedia).Error; err != nil {
			return err // 트랜잭션 자동 롤백됨
		}

		return nil // 트랜잭션 커밋
	})

	// ✅ 4. 트랜잭션 에러 처리
	if err != nil {
		if fiberErr, ok := err.(*fiber.Error); ok {
			return c.Status(fiberErr.Code).JSON(fiber.Map{"error": fiberErr.Message})
		}
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "failed to create background media"})
	}

	// ✅ 5. 성공 응답 반환
	return c.Status(fiber.StatusCreated).JSON(fiber.Map{
		"message": "background media created successfully",
		"data":    bgMedia,
	})
}

func updatePersonaBackgroundMedia(c fiber.Ctx) error {
	// ✅ 1. 패스 파라미터에서 persona_id 가져오기
	personaID := c.Params("persona_id")
	if personaID == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "persona_id is required"})
	}

	// ✅ 2. 요청 바디에서 업데이트할 필드만 파싱
	var request map[string]interface{}
	if err := json.Unmarshal(c.Body(), &request); err != nil || len(request) == 0 {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "at least one field is required"})
	}

	// ✅ 3. 트랜잭션 시작
	var updatedData model.PersonaBackgroundMedia
	err := config.DB.Transaction(func(tx *gorm.DB) error {
		// ✅ 3-1. 권한 검증
		if err := validatePersonaAccess(c, tx, personaID); err != nil {
			return err
		}

		// ✅ 3-2. persona_id 기반으로 persona_profile_id 조회 (1:1 관계)
		var personaProfileID string
		if err := tx.Table("persona_profile").
			Select("id").
			Where("persona_id = ?", personaID).
			Scan(&personaProfileID).Error; err != nil {
			return fiber.NewError(fiber.StatusNotFound, "persona profile not found")
		}

		// ✅ 3-3. 기존 배경 미디어 존재 여부 확인
		var existing model.PersonaBackgroundMedia
		if err := tx.Where("persona_profile_id = ?", personaProfileID).First(&existing).Error; err != nil {
			return fiber.NewError(fiber.StatusNotFound, "background media not found")
		}

		// ✅ 3-4. 변경된 필드만 업데이트
		if err := tx.Model(&existing).Updates(request).Error; err != nil {
			return fiber.NewError(fiber.StatusInternalServerError, "failed to update background media")
		}

		// ✅ 3-5. 업데이트된 데이터 조회 (최종 반환용)
		if err := tx.Where("id = ?", existing.ID).First(&updatedData).Error; err != nil {
			return fiber.NewError(fiber.StatusInternalServerError, "failed to retrieve updated data")
		}

		return nil // 트랜잭션 커밋
	})

	// ✅ 4. 트랜잭션 에러 처리
	if err != nil {
		if fiberErr, ok := err.(*fiber.Error); ok {
			return c.Status(fiberErr.Code).JSON(fiber.Map{"error": fiberErr.Message})
		}
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "failed to update background media"})
	}

	// ✅ 5. 성공 응답 반환 (반환 형식 `{message: , data: }` 유지)
	return c.JSON(fiber.Map{
		"message": "background media updated successfully",
		"data":    updatedData,
	})
}

func deletePersonaBackgroundMedia(c fiber.Ctx) error {
	// ✅ 1. 패스 파라미터에서 persona_id 가져오기
	personaID := c.Params("persona_id")
	if personaID == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "persona_id is required"})
	}

	// ✅ 2. 트랜잭션 시작
	var deletedData model.PersonaBackgroundMedia
	err := config.DB.Transaction(func(tx *gorm.DB) error {
		// ✅ 2-1. 권한 검증
		if err := validatePersonaAccess(c, tx, personaID); err != nil {
			return err
		}

		// ✅ 2-2. persona_id 기반으로 persona_profile_id 조회 (1:1 관계)
		var personaProfileID string
		if err := tx.Table("persona_profile").
			Select("id").
			Where("persona_id = ?", personaID).
			Scan(&personaProfileID).Error; err != nil {
			return fiber.NewError(fiber.StatusNotFound, "persona profile not found")
		}

		// ✅ 2-3. 기존 배경 미디어 존재 여부 확인
		if err := tx.Where("persona_profile_id = ?", personaProfileID).
			First(&deletedData).Error; err != nil {
			return fiber.NewError(fiber.StatusNotFound, "background media not found")
		}

		// ✅ 2-4. 배경 미디어 삭제
		if err := tx.Delete(&deletedData).Error; err != nil {
			return fiber.NewError(fiber.StatusInternalServerError, "failed to delete background media")
		}

		return nil // 트랜잭션 커밋
	})

	// ✅ 3. 트랜잭션 에러 처리
	if err != nil {
		if fiberErr, ok := err.(*fiber.Error); ok {
			return c.Status(fiberErr.Code).JSON(fiber.Map{"error": fiberErr.Message})
		}
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "failed to delete background media"})
	}

	// ✅ 4. 성공 응답 반환 (반환 형식 `{message: , data: }` 유지)
	return c.JSON(fiber.Map{
		"message": "background media deleted successfully",
		"data":    deletedData,
	})
}

// ✅ 권한 검증 함수 (해당 파일 내에서만 사용)
func validatePersonaAccess(c fiber.Ctx, tx *gorm.DB, personaID string) error {
	// ✅ 헤더에서 Bearer 토큰으로 DID 추출
	authDid, err := authority.ExtractBaererHeader(c)
	if err != nil {
		return fiber.NewError(fiber.StatusUnauthorized, "unauthorized")
	}

	// ✅ persona_id 기반으로 persona_type 조회
	var persona struct {
		PersonaType string `gorm:"column:persona_type"`
		Did         string `gorm:"column:did"`
	}
	if err := tx.Table("persona").
		Select("persona_type, did").
		Where("id = ?", personaID).
		Scan(&persona).Error; err != nil {
		return fiber.NewError(fiber.StatusInternalServerError, "failed to get persona type")
	}

	// ✅ 조직(organization)일 경우 멤버 권한 검증
	if persona.PersonaType == "organization" {
		if err := authority.ValidateMember(c, personaID, "manager"); err != nil {
			return fiber.NewError(fiber.StatusForbidden, "unauthorized")
		}
	} else {
		// ✅ 개인(personal)일 경우 DID 검증
		var count int64
		if err := tx.Table("persona").
			Where("did = ? AND id = ?", authDid, personaID).
			Count(&count).Error; err != nil {
			return fiber.NewError(fiber.StatusInternalServerError, "failed to verify persona ownership")
		}

		if count == 0 {
			return fiber.NewError(fiber.StatusForbidden, "unauthorized")
		}
	}

	return nil // ✅ 권한 검증 성공
}
