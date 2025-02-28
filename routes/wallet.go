package routes

import (
	"encoding/json"
	"errors"
	"fiber_server/config"
	"fiber_server/model"
	"fiber_server/routes/middleware"
	"fiber_server/routes/middleware/authority"
	"fmt"
	"log"
	"strings"
	"time"

	"github.com/gofiber/fiber/v3"
	"gorm.io/gorm"
)

// 회원의 Wallet정보에 대해 DB에서 검사하는 ORM형식의 개체

// Wallet 라우트 설정
func SetupWalletRoutes(app *fiber.App) {

	walletGroup := app.Group("/wallet")
	walletGroup.Use(middleware.WalletParamsLogger)
	// Wallet정보 목록 검사
	walletGroup.Get("/", getHandler)
	walletGroup.Get("/import", importWallet)
	// Wallet의 모든 Personas 검사
	walletGroup.Get("/personas", getAllPersonas)
	// Wallet 계정 생성
	walletGroup.Post("/", createWallet)
	walletGroup.Patch("/email", updateWalletEmail)
	walletGroup.Delete("/", deleteWallet)
	// Persona 이관
	walletGroup.Post("/transfer-persona", transferPersona)
}

func getHandler(c fiber.Ctx) error {
	did, err := authority.ExtractBaererHeader(c)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "DID is required",
		})
	}
	action := c.Query("action") // 쿼리 파라미터에서 'action' 값 추출. 단순한 조회시: 'get', Migration시: 'migrate'
	log.Printf("🔍 Received DID from query: %s", did)
	log.Printf("🔍 Received Action from query: %s", action)

	if action == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Action is required",
		})
	}
	if action == "get" {
		return getWallet(c, did)
	}

	if action == "migrate" {
		email := c.Query("email")
		return migrateWallet(c, did, email)
	}

	return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
		"error": "Invalid action",
	})
}

func getWallet(c fiber.Ctx, did string) error {

	var wallet model.Wallet
	// DB에서 DID로 지갑 조회
	err := config.DB.Model(&model.Wallet{}).First(&wallet, "did = ?", did).Error
	if err != nil {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error": "Wallet not found",
		})
	}

	// var personas []model.Persona
	// config.DB.Preload("OwnedPosts").Preload("Members").Preload("MemberOf").Preload("Profile").Where("did = ?", did).Find(&personas)

	// wallet.Personas = personas

	// Wallet과 관련된 Personas 포함하여 반환
	return c.JSON(fiber.Map{
		"message": "Wallet retrieved successfully",
		"data":    wallet,
	})
}

func migrateWallet(c fiber.Ctx, did string, email string) error {
	// 이메일 값이 없을 경우 에러 반환
	if email == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Email is required for migration",
		})
	}

	// 이메일과 일치하는 persona profile 찾기
	var personaProfile model.PersonaProfile
	if err := config.DB.Where("email = ?", email).First(&personaProfile).Error; err != nil {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error": "Persona profile not found",
		})
	}

	// persona profile에서 persona_id 추출
	personaID := personaProfile.PersonaID

	// persona_id와 일치하는 persona 찾기
	var persona model.Persona
	if err := config.DB.Where("id = ?", personaID).First(&persona).Error; err != nil {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error": "Persona not found",
		})
	}

	// 예전 DID 조회
	oldDid := persona.Did
	if len(oldDid) >= 7 {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Not a legacy user",
		})
	}

	// 예전 DID로 wallet 찾기
	var wallet model.Wallet
	if err := config.DB.Where("did = ?", oldDid).First(&wallet).Error; err != nil {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error": "Wallet not found",
		})
	}

	// wallet의 DID를 현재 수신한 DID로 업데이트
	if err := config.DB.Model(&wallet).Where("did = ?", oldDid).Update("did", did).Error; err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Failed to update wallet",
		})
	}

	// persona의 DID를 현재 수신한 DID로 업데이트
	updates := map[string]interface{}{
		"did": did,
	}

	if err := config.DB.Model(&persona).Updates(updates).Error; err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Failed to update persona",
		})
	}

	// 마이그레이션 성공한 wallet 반환
	return c.JSON(fiber.Map{
		"message": "Wallet migrated successfully!",
		"data":    wallet,
	})
}

func importWallet(c fiber.Ctx) error {
	email := c.Query("email")
	if email == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Email is required for migration",
		})
	}

	var wallets []model.Wallet
	if err := config.DB.Where("email = ?", email).Find(&wallets).Error; err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Failed to fetch wallets",
		})
	}

	// 결과가 없는 경우
	if len(wallets) == 0 {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error": "No wallets found with given email",
		})
	}

	return c.JSON(fiber.Map{
		"message": "Wallets retrieved successfully",
		"data":    wallets,
	})
}

// READ: 모든 페르소나 조회
func getAllPersonas(c fiber.Ctx) error {
	did, err := authority.ExtractBaererHeader(c)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "DID is required",
		})
	}
	var personas []model.Persona
	if did == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "DID is required",
		})
	}
	result := config.DB.
		Preload("OwnedPosts").
		Preload("OwnedPosts.Author").         // 🟢 Owner 로드
		Preload("OwnedPosts.Author.Profile"). // 🟢 Owner의 Profile 로드
		Preload("Members.MemberPersona").     // 내 채널에 가입한 페르소나들
		Preload("Members.MemberPersona.Profile").
		Preload("MemberOf.Persona"). // 내가 가입한 채널들
		Preload("MemberOf.Persona.Profile").
		Preload("Subscribes", "status = ?", "approved"). // 승인된 구독만
		Preload("Subscribers", "status = ?", "approved").
		Preload("BusinessOrganizationInfo").
		Preload("BusinessIndividualInfo").
		Preload("Profile").
		Preload("Profile.BackgroundMedia").
		Where("did = ?", did).
		Find(&personas)

	if result.Error != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": result.Error.Error(),
		})
	}
	return c.JSON(fiber.Map{
		"message": "Persona retrieved successfully",
		"data":    personas,
	})
}

func createWallet(c fiber.Ctx) error {
	var input struct {
		Did                string `json:"did"`
		Email              string `json:"email,omitempty"`
		MembershipType     string `json:"membershipType,omitempty"`
		RegistrationSource string `json:"registrationSource,omitempty"`
	}

	if err := json.Unmarshal(c.Body(), &input); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Invalid request format",
		})
	}

	if input.Did == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "DID is required",
		})
	}

	// 🚀 Wallet 생성 - 기본값은 GORM 태그에서 처리됨
	wallet := &model.Wallet{
		Did:                input.Did,
		Email:              input.Email,
		MembershipType:     input.MembershipType,     // 비어있으면 GORM이 기본값 "free" 사용
		RegistrationSource: input.RegistrationSource, // 비어있으면 GORM이 기본값 "mobile_app" 사용
	}

	err := config.DB.Create(wallet).Error
	if err != nil {
		if strings.Contains(err.Error(), "duplicate key value") {
			return c.Status(fiber.StatusConflict).JSON(fiber.Map{
				"error": "Wallet with this DID already exists",
			})
		}
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Failed to create wallet",
		})
	}
	return c.Status(fiber.StatusCreated).JSON(fiber.Map{
		"message": "Wallet created successfully!",
		"data":    wallet,
	})
}

func updateWalletEmail(c fiber.Ctx) error {
	did, err := authority.ExtractBaererHeader(c)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "DID is required",
		})
	}
	email := c.Query("email")
	if email == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Email is required",
		})
	}

	var wallet model.Wallet

	// 트랜잭션 시작
	err = config.DB.Transaction(func(tx *gorm.DB) error {
		// 1. 월렛 존재 여부 확인
		if err := tx.Where("did = ?", did).First(&wallet).Error; err != nil {
			if errors.Is(err, gorm.ErrRecordNotFound) {
				return errors.New("wallet not found")
			}
			return err
		}

		// 2. 이메일 업데이트
		if err := tx.Model(&wallet).Update("email", email).Error; err != nil {
			return err
		}

		return nil
	})

	// 에러 처리
	if err != nil {
		switch err.Error() {
		case "wallet not found":
			return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
				"error": "Wallet not found",
			})
		default:
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"error": "Failed to update email",
			})
		}
	}

	return c.JSON(fiber.Map{
		"message": "Email updated successfully",
		"data":    wallet,
	})
}

func deleteWallet(c fiber.Ctx) error {
	did, err := authority.ExtractBaererHeader(c)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "DID is required",
		})
	}

	// x-timestamp 헤더에서 생성 시간 확인
	timestampStr := c.Get("x-timestamp")
	if timestampStr == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Creation timestamp is required",
		})
	}

	// ISO8601 문자열을 시간으로 파싱
	expectedTime, err := time.Parse(time.RFC3339, timestampStr)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Invalid timestamp format",
		})
	}

	log.Printf("🔍 Deleting wallet with DID: %s, Expected creation time: %s", did, expectedTime)

	var wallet model.Wallet

	// 트랜잭션 시작
	err = config.DB.Transaction(func(tx *gorm.DB) error {
		// 1. 지갑 조회
		if err := tx.Where("did = ?", did).First(&wallet).Error; err != nil {
			return err
		}

		// 생성 시간 검증 (초 단위까지만 비교)
		if wallet.CreatedAt.Unix() != expectedTime.Unix() {
			log.Printf("❌ Timestamp mismatch - Expected: %v, Actual: %v", expectedTime, wallet.CreatedAt)
			return fmt.Errorf("timestamp mismatch")
		}

		// 2. 지갑 삭제 - cascade는 DB 레벨에서 자동으로 동작
		if err := tx.Delete(&wallet).Error; err != nil {
			return err
		}

		return nil
	})

	if err != nil {
		switch {
		case errors.Is(err, gorm.ErrRecordNotFound):
			return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
				"error": "Wallet not found",
			})
		case err.Error() == "timestamp mismatch":
			return c.Status(fiber.StatusConflict).JSON(fiber.Map{
				"error":    "Creation timestamp does not match",
				"expected": wallet.CreatedAt.Format(time.RFC3339),
			})
		default:
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"error": "Failed to delete wallet",
			})
		}
	}

	return c.JSON(fiber.Map{
		"message": "Wallet and all related records deleted successfully",
		"data":    wallet,
	})
}

// transferPersona : Persona 이관 처리
func transferPersona(c fiber.Ctx) error {
	// DID로 소유자 검증
	did, err := authority.ExtractBaererHeader(c)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "DID is required",
		})
	}

	// 요청 데이터 파싱
	var input struct {
		PersonaID    string `json:"persona_id"`    // 이관할 Persona ID
		TargetDID    string `json:"target_did"`    // 이관 대상 Wallet의 DID
		TransferCode string `json:"transfer_code"` // 이관 인증 코드
	}

	if err := json.Unmarshal(c.Body(), &input); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "invalid request body",
		})
	}

	// 필수 필드 검증
	if input.PersonaID == "" || input.TargetDID == "" || input.TransferCode == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "persona_id, target_did, and transfer_code are required",
		})
	}

	// 트랜잭션 시작
	err = config.DB.Transaction(func(tx *gorm.DB) error {
		// 1. 현재 소유자 Wallet 조회
		var currentWallet model.Wallet
		if err := tx.Where("did = ?", did).First(&currentWallet).Error; err != nil {
			return fmt.Errorf("current wallet not found")
		}

		// 2. 이관 대상 Wallet 조회
		var targetWallet model.Wallet
		if err := tx.Where("did = ?", input.TargetDID).First(&targetWallet).Error; err != nil {
			return fmt.Errorf("target wallet not found")
		}

		// 3. 이관할 Persona 조회 및 소유권 검증
		var persona model.Persona
		if err := tx.Where("id = ? AND did = ?", input.PersonaID, did).First(&persona).Error; err != nil {
			return fmt.Errorf("persona not found or unauthorized")
		}

		// 4. 이관 코드 검증 (실제 구현에서는 더 복잡한 검증 로직 필요)
		if !validateTransferCode(input.TransferCode) {
			return fmt.Errorf("invalid transfer code")
		}

		// 5. Persona 이관 처리
		updates := map[string]interface{}{
			"did": input.TargetDID,
		}

		if err := tx.Model(&persona).Updates(updates).Error; err != nil {
			return fmt.Errorf("failed to transfer persona")
		}

		// 6. 알림 설정 이관 (선택적)
		var personaPref model.PersonaNotificationPreference
		if err := tx.Where("persona_id = ?", input.PersonaID).First(&personaPref).Error; err == nil {
			// 알림 설정이 있는 경우, 새로운 Wallet의 NotificationPreference에 연결
			var targetPref model.NotificationPreference
			if err := tx.Where("wallet_did = ?", input.TargetDID).First(&targetPref).Error; err == nil {
				personaPref.PreferenceID = targetPref.ID
				if err := tx.Save(&personaPref).Error; err != nil {
					return fmt.Errorf("failed to transfer notification settings")
				}
			}
		}

		log.Printf("✅ Persona transferred successfully - ID: %s, From: %s, To: %s",
			input.PersonaID, did, input.TargetDID)
		return nil
	})

	// 에러 처리
	if err != nil {
		switch err.Error() {
		case "current wallet not found":
			return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
				"error": "current wallet not found",
			})
		case "target wallet not found":
			return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
				"error": "target wallet not found",
			})
		case "persona not found or unauthorized":
			return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
				"error": "persona not found or unauthorized",
			})
		case "invalid transfer code":
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
				"error": "invalid transfer code",
			})
		default:
			log.Printf("❌ Internal error: %v", err)
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"error": "failed to process request",
			})
		}
	}

	// 성공 응답
	return c.JSON(fiber.Map{
		"message": "persona transferred successfully",
		"data": fiber.Map{
			"persona_id": input.PersonaID,
			"from_did":   did,
			"to_did":     input.TargetDID,
		},
	})
}

// validateTransferCode : 이관 코드 검증 (예시 구현)
func validateTransferCode(code string) bool {
	// 실제 구현에서는 더 복잡한 검증 로직이 필요
	// 예: DB에서 코드 검증, 만료 시간 확인 등
	return len(code) >= 6 // 임시 구현
}
