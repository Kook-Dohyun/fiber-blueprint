package authority

import (
	"errors"
	"fiber_server/config"
	"log"

	"github.com/gofiber/fiber/v3"
	"gorm.io/gorm"
)

// ✅ `ValidateMember` 함수 (단일 호출로 인증 & 권한 검증)
func ValidateMember(c fiber.Ctx, targetID string, authLevel string) error {
	// 헤더에서 Bearer 토큰을 가져와서 `persona_id` 추출
	authPersonaID, err := ExtractBaererHeader(c)
	if err != nil {
		return err
	}

	// ✅ 본인이 자신의 데이터 수정하는 경우, 자동 승인
	if authPersonaID == targetID {
		return nil
	}

	// ✅ `persona_member` 테이블에서 권한 확인
	db := config.DB
	var role string

	err = db.Table("persona_member").
		Select("role").
		Where("persona_id = ? AND member_persona_id = ?", targetID, authPersonaID).
		Scan(&role).Error

	if err != nil || role == "" {
		return errors.New("doen't have permission")
	}

	// ✅ 요구되는 권한 수준과 비교
	validRoles := map[string]int{
		"member":  1,
		"manager": 2,
		"admin":   3,
	}

	// 요청된 권한보다 낮으면 거부
	if validRoles[role] < validRoles[authLevel] {
		return errors.New("less permission")
	}

	// ✅ 모든 검증 통과
	return nil
}

func ValidateOwnerByDid(c fiber.Ctx, tx *gorm.DB, ownerID string) error {
	// 1. Bearer 토큰에서 DID 추출
	authDid, err := ExtractBaererHeader(c)
	if err != nil {
		log.Printf("❌ Failed to extract DID from token: %v", err)
		return errors.New("unauthorized")
	}

	// 2. 소유자의 DID 확인
	var ownerDid string
	if err := tx.Table("persona").
		Select("did").
		Where("id = ?", ownerID).
		Scan(&ownerDid).Error; err != nil {
		log.Printf("❌ Failed to fetch owner DID: %v", err)
		return err
	}

	// 3. DID 일치 여부 확인
	if ownerDid != authDid {
		log.Printf("❌ Unauthorized - Owner DID: %s, Requester DID: %s",
			ownerDid, authDid)
		return errors.New("unauthorized")
	}

	return nil
}
