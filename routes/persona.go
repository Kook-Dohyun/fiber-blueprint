package routes

import (
	"encoding/json"
	"errors"
	"fiber_server/config"
	"fiber_server/model"
	"fiber_server/routes/middleware/authority"
	"reflect"

	"github.com/gofiber/fiber/v3"
	"github.com/lib/pq"
	"gorm.io/gorm"
)

func SetupPersonaRoutes(app *fiber.App) {
	personaGroup := app.Group("/persona")

	// CREATE: 새로운 페르소나 생성
	personaGroup.Post("/", createPersona)
	// READ: 모든 페르소나 조회
	// personaGroup.Get("/", getAllPersonas)
	// READ: 특정 페르소나 조회
	personaGroup.Get("/:id", getPersona)
	// UPDATE: 페르소나 정보 업데이트
	personaGroup.Put("/:id", updatePersona)
	personaGroup.Put("/:id/lastActivity", UpdatePersonaActivity)
	// DELETE: 페르소나 삭제
	personaGroup.Delete("/:id", deletePersona)
}

func createPersona(c fiber.Ctx) error {
	// 요청 데이터 파싱
	var input struct {
		PersonaType  model.PersonaType  `json:"persona_type"`
		BusinessType model.BusinessType `json:"business_type,omitempty"`
	}

	if err := json.Unmarshal(c.Body(), &input); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "invalid request body",
		})
	}

	// PersonaType 검증
	switch input.PersonaType {
	case model.PersonaTypePersonal, model.PersonaTypeOrganization:
		// 유효한 타입
	default:
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "invalid persona_type. must be 'personal' or 'organization'",
		})
	}

	// Bearer 토큰에서 DID 추출
	did, err := authority.ExtractBaererHeader(c)
	if err != nil {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
			"error": "unauthorized",
		})
	}

	// 새 페르소나 생성
	persona := &model.Persona{
		Did:          did,
		PersonaType:  input.PersonaType,
		BusinessType: input.BusinessType,
	}

	// DB에 저장
	if err := config.DB.Create(persona).Error; err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "failed to create persona",
		})
	}

	return c.Status(fiber.StatusCreated).JSON(fiber.Map{
		"message": "persona created successfully",
		"data":    persona,
	})
}

// READ: 특정 페르소나 조회
func getPersona(c fiber.Ctx) error {
	id := c.Params("id")
	persona := new(model.Persona)

	if err := config.DB.
		Preload("OwnedPosts").
		Preload("OwnedPosts.Author.Profile").
		Preload("Members").
		Preload("Members.Persona").
		Preload("Members.Persona.Profile").
		Preload("MemberOf").
		Preload("MemberOf.Persona").
		Preload("MemberOf.Persona.Profile").
		Preload("Profile").
		Preload("Subscribes").
		Preload("Subscribers").
		Preload("BusinessOrganizationInfo").
		Preload("BusinessIndividualInfo").
		First(&persona, "id = ?", id).
		Error; err != nil {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error": "페르소나를 찾을 수 없습니다",
		})
	}

	return c.JSON(fiber.Map{
		"message": "페르소나 조회 성공",
		"data":    persona,
	})
}

// UPDATE: 페르소나 정보 업데이트
func updatePersona(c fiber.Ctx) error {
	id := c.Params("id")

	//  DID로 소유자 검증
	if err := authority.ValidateOwnerByDid(c, config.DB, id); err != nil {
		return err
	}

	// 요청 데이터 파싱 (맵으로 받음)
	var input map[string]interface{}

	if err := json.Unmarshal(c.Body(), &input); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "wrong request data"}) // ✅ 잘못된 요청 데이터인 경우 오류 반환
	}
	// 요청된 필드가 없는 경우 오류 반환
	if len(input) == 0 {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "field is required"}) // ✅ 필드가 없는 경우 오류 반환
	}

	// ✅ `PersonaProfile` 구조체의 `pq.StringArray` 필드 자동 변환
	p := model.Persona{}
	t := reflect.TypeOf(p)

	for fieldName, fieldValue := range input {
		// `PersonaProfile` 구조체에서 해당 필드 타입 확인
		for i := 0; i < t.NumField(); i++ {
			field := t.Field(i)
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
					input[fieldName] = pq.StringArray(stringList) // ✅ `TEXT[]` 변환 적용
				} else {
					return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
						"error": fieldName + " field must be a string array",
					})
				}
			}
		}
	}

	// DB 업데이트
	db := config.DB
	if err := db.Model(&model.Persona{}).
		Where("id = ?", id).
		Updates(input).Error; err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "persona update failed"})
	}

	return c.JSON(fiber.Map{"message": "persona updated successfully", "data": input})

}

func UpdatePersonaActivity(c fiber.Ctx) error {
	id := c.Params("id")

	// DB에서 특정 컬럼을 업데이트하면 `updated_at`이 자동 갱신됨
	db := config.DB
	if err := db.Model(&model.Persona{}).Where("id = ?", id).Update("id", id).Error; err != nil {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{"error": fiber.ErrNotFound})
	}
	// log.Printf("✅ Persona Activity Updated %s", id)
	return c.JSON(fiber.Map{"message": "updated time"})
}

// DELETE: 페르소나 삭제
func deletePersona(c fiber.Ctx) error {
	id := c.Params("id")
	if id == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "persona id is required",
		})
	}

	var persona model.Persona

	// 트랜잭션 시작
	err := config.DB.Transaction(func(tx *gorm.DB) error {
		// 1. 페르소나 조회
		if err := tx.First(&persona, "id = ?", id).Error; err != nil {
			return err
		}

		// 2. 페르소나 삭제 (cascade는 DB 레벨에서 자동으로 동작)
		if err := tx.Delete(&persona).Error; err != nil {
			return err
		}

		return nil
	})

	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
				"error": "persona not found",
			})
		}
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "failed to delete persona",
		})
	}

	return c.JSON(fiber.Map{
		"message": "persona deleted successfully",
		"data":    persona,
	})
}
