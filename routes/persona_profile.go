package routes

import (
	"encoding/json"
	"errors"
	"fiber_server/config"
	"fiber_server/helper"
	"fiber_server/model"
	"fiber_server/routes/middleware/authority"
	"log"
	"reflect"
	"strings"

	"github.com/gofiber/fiber/v3"
	"github.com/lib/pq"
	"gorm.io/gorm"
)

func SetupPersonaProfileRoutes(app *fiber.App) {
	profileGroup := app.Group("/persona/profile")
	profileGroup.Get("/:persona_id", getPersonaProfile)
	profileGroup.Post("/", createPersonaProfile)
	profileGroup.Put("/:persona_id", updatePersonaProfile)
	profileGroup.Delete("/:persona_id", deletePersonaProfile)
}
func getPersonaProfile(c fiber.Ctx) error {
	id := c.Params("persona_id")
	fields := c.Query("fields")

	// 기본 쿼리 설정
	query := config.DB.Model(&model.PersonaProfile{}).Where("persona_id = ?", id)

	var result map[string]interface{}

	if fields != "" {
		// 요청된 필드만 선택
		fieldList := strings.Split(fields, ",")
		query = query.Select(fieldList)

		// map으로 결과 받기
		if err := query.Take(&result).Error; err != nil {
			return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
				"error": "cannot find profile",
			})
		}
	} else {
		// 모든 필드 조회
		var profile model.PersonaProfile
		if err := query.First(&profile).Error; err != nil {
			return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
				"error": "cannot find profile",
			})
		}
		result = map[string]interface{}{
			"id":                 profile.ID,
			"persona_id":         profile.PersonaID,
			"display_name":       profile.DisplayName,
			"profile_image_url":  profile.ProfileImageURL,
			"description":        profile.Description,
			"email":              profile.Email,
			"email_shown":        profile.EmailShown,
			"phone_number":       profile.PhoneNumber,
			"phone_number_shown": profile.PhoneNumberShown,
			"website":            profile.Website,
			"tags":               profile.Tags,
			"created_at":         profile.CreatedAt,
			"updated_at":         profile.UpdatedAt,
		}
	}

	return c.JSON(fiber.Map{
		"message": "profile retrieved successfully",
		"data":    result,
	})
}

func createPersonaProfile(c fiber.Ctx) error {
	var input struct {
		PersonaID        string         `json:"persona_id"`
		DisplayName      string         `json:"display_name"`
		ProfileImageURL  string         `json:"profile_image_url,omitempty"`
		Description      string         `json:"description,omitempty"`
		Email            string         `json:"email,omitempty"`
		EmailShown       bool           `json:"email_shown,omitempty"`
		PhoneNumber      string         `json:"phone_number,omitempty"`
		PhoneNumberShown bool           `json:"phone_number_shown,omitempty"`
		Website          string         `json:"website,omitempty"`
		Tags             pq.StringArray `json:"tags"`
	}
	if err := json.Unmarshal(c.Body(), &input); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "잘못된 요청 형식입니다",
		})
	}

	// 필수 필드 검증
	if input.PersonaID == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "persona_id is required",
		})
	}
	if input.DisplayName == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "display_name is required",
		})
	}
	// DID로 소유자 검증
	if err := authority.ValidateOwnerByDid(c, config.DB, input.PersonaID); err != nil {
		return err
	}

	// PersonaProfile 생성
	profile := &model.PersonaProfile{
		PersonaID:        input.PersonaID,
		DisplayName:      input.DisplayName,
		ProfileImageURL:  helper.StrPtr(input.ProfileImageURL),
		Description:      helper.StrPtr(input.Description),
		Email:            input.Email,
		EmailShown:       input.EmailShown,
		PhoneNumber:      input.PhoneNumber,
		PhoneNumberShown: input.PhoneNumberShown,
		Website:          input.Website,
		Tags:             pq.StringArray(input.Tags),
	}

	// DB에 저장
	if err := config.DB.Create(profile).Error; err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "failed to create profile",
		})
	}

	return c.Status(fiber.StatusCreated).JSON(fiber.Map{
		"message": "profile created successfully",
		"data":    profile,
	})
}

// ✅ Body에서 받은 필드만 업데이트하는 PUT 메소드
func updatePersonaProfile(c fiber.Ctx) error {

	// 요청 데이터 파싱 (맵으로 받음)
	var request map[string]interface{}

	if err := json.Unmarshal(c.Body(), &request); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "wrong request data"}) // ✅ 잘못된 요청 데이터인 경우 오류 반환
	}

	// 요청된 필드가 없는 경우 오류 반환
	if len(request) == 0 {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "field is required"})
	}

	// 패스 파라미터에서 `targetID` (수정하려는 페르소나 ID) 가져오기
	targetID := c.Params("persona_id")
	if targetID == "" {
		return c.Status(500).JSON(fiber.Map{"error": "target persona id is required"})
	}
	// ✅ 1. 대상 페르소나의 타입 확인 (personal인지 organization인지)
	db := config.DB
	var personaType string
	err := db.Table("persona").
		Select("persona_type").
		Where("id = ?", targetID).
		Scan(&personaType).Error

	if err != nil {
		return c.Status(fiber.StatusExpectationFailed).JSON(fiber.Map{"error": "failed to get persona type"})
	}
	// ✅ 2. `persona_type`이 `personal`이면 권한 검증 없이 진행
	if personaType == "organization" {
		err = authority.ValidateMember(c, targetID, "manager")
		if err != nil {
			return c.Status(fiber.StatusForbidden).JSON(fiber.Map{"error": err.Error()})
		}
	}

	id := targetID

	// ✅ `PersonaProfile` 구조체의 `pq.StringArray` 필드 자동 변환
	profileModel := model.PersonaProfile{}
	profileType := reflect.TypeOf(profileModel)

	for fieldName, fieldValue := range request {
		// `PersonaProfile` 구조체에서 해당 필드 타입 확인
		for i := 0; i < profileType.NumField(); i++ {
			field := profileType.Field(i)
			jsonTag := field.Tag.Get("json") // ✅ JSON 태그 가져오기

			// JSON 태그가 요청된 필드명과 일치하는 경우
			if jsonTag == fieldName && field.Type == reflect.TypeOf(pq.StringArray{}) {
				if list, ok := fieldValue.([]interface{}); ok {
					var stringList []string
					for _, val := range list {
						if str, isString := val.(string); isString {
							stringList = append(stringList, str)
						}
					}
					request[fieldName] = pq.StringArray(stringList) // ✅ `TEXT[]` 변환 적용
				} else {
					return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
						"error": fieldName + " field must be a string array",
					})
				}
			}
		}
	}

	// DB 업데이트
	if err := db.Model(&model.PersonaProfile{}).
		Where("persona_id = ?", id).
		Updates(request).Error; err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "profile update failed"}) // ✅ 프로필 업데이트 실패 시 오류 반환
	}

	return c.Status(fiber.StatusCreated).JSON(fiber.Map{"message": "profile updated successfully", "data": request})
}

// deletePersonaProfile : 프로필 삭제
func deletePersonaProfile(c fiber.Ctx) error {
	targetID := c.Params("persona_id")
	if targetID == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "need target persona id",
		})
	}

	var profile model.PersonaProfile

	// 트랜잭션 시작
	err := config.DB.Transaction(func(tx *gorm.DB) error {
		// 1. 페르소나 타입과 DID 확인
		var persona struct {
			PersonaType string `gorm:"column:persona_type"`
			Did         string `gorm:"column:did"`
		}
		if err := tx.Table("persona").
			Select("persona_type, did").
			Where("id = ?", targetID).
			Scan(&persona).Error; err != nil {
			log.Printf("❌ Failed to fetch persona: %v", err)
			return err
		}

		// 2. 권한 검증
		if persona.PersonaType == "organization" {
			if err := authority.ValidateMember(c, targetID, "admin"); err != nil {
				return c.Status(fiber.StatusForbidden).JSON(fiber.Map{"error": err.Error()})
			}
		} else {
			authDid, err := authority.ExtractBaererHeader(c)
			if err != nil {
				log.Printf("❌ Failed to extract DID from token: %v", err)
				return errors.New("unauthorized")
			}

			var count int64
			if err := tx.Table("persona").
				Where("did = ? AND id = ?", authDid, targetID).
				Count(&count).Error; err != nil {
				log.Printf("❌ Failed to verify persona ownership: %v", err)
				return errors.New("unauthorized")
			}

			if count == 0 {
				log.Printf("❌ Unauthorized access - DID: %s, Persona ID: %s", authDid, targetID)
				return errors.New("unauthorized")
			}
		}

		// 3. 프로필 조회
		if err := tx.Where("persona_id = ?", targetID).First(&profile).Error; err != nil {
			log.Printf("❌ Failed to fetch profile: %v", err)
			return err
		}

		// 4. 프로필 삭제
		if err := tx.Delete(&profile).Error; err != nil {
			log.Printf("❌ Failed to delete profile: %v", err)
			return err
		}

		log.Printf("✅ Profile deleted successfully - ID: %s", targetID)
		return nil
	})

	if err != nil {
		switch {
		case errors.Is(err, gorm.ErrRecordNotFound):
			return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
				"error": "cannot find profile",
			})
		case err.Error() == "unauthorized":
			return c.Status(fiber.StatusForbidden).JSON(fiber.Map{
				"error": "unauthorized",
			})
		default:
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"error": "failed to delete profile",
			})
		}
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"message": "profile deleted successfully",
		"data":    profile,
	})
}
