package routes

import (
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"fiber_server/config"
	"fiber_server/model"
	"fiber_server/routes/middleware/authority"
	"fmt"
	"log"
	"regexp"
	"time"

	"github.com/gofiber/fiber/v3"
)

// 라우트 설정
func SetupAdminRoutes(app *fiber.App) {
	adminGroup := app.Group("/admin")
	adminGroup.Get("/", getAdmins)
	adminGroup.Post("/", createAdmin)

}

// 📌 GET /admin → 관리자 계정 조회
// 📌 GET /admin → 관리자 계정 조회
func getAdmins(c fiber.Ctx) error {
	// ✅ `checkAdminAuth()`를 호출하고 인증 실패 시 즉시 403 반환
	if !authority.CheckAdminAuth(c) {
		return c.Status(fiber.StatusForbidden).JSON(fiber.Map{
			"error": "Access denied: Invalid admin credentials",
		})
	}

	log.Println("✅ Authentication passed, retrieving all wallet data...")

	// 🔍 Wallet 테이블에서 모든 데이터 가져오기
	var wallets []model.Wallet
	if err := config.DB.Find(&wallets).Error; err != nil {
		log.Println("❌ Failed to fetch wallet records:", err)
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Failed to retrieve wallet accounts",
		})
	}

	// 🔍 반환된 Wallet 데이터 개수 확인
	log.Println("📋 Found Wallet records:", len(wallets))
	if len(wallets) == 0 {
		log.Println("⚠️ No wallet records found, returning empty response")
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error": "No wallet records found",
		})
	}

	// ✅ 정상적인 JSON 응답 확인
	log.Println("✅ Sending Wallet records as JSON response")
	return c.JSON(fiber.Map{
		"message": "Wallets retrieved successfully",
		"data":    wallets,
	})
}

// 📌 POST /admin → 관리자 계정 생성
func createAdmin(c fiber.Ctx) error {
	// 요청 본문 JSON 파싱
	var input struct {
		Username string `json:"username"`
		Password string `json:"password"`
	}

	if err := json.Unmarshal(c.Body(), &input); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Invalid request format",
		})
	}

	// 입력값 검증
	if input.Username == "" || input.Password == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Username and password are required",
		})
	}

	// 사용자명 검증 (알파벳 + 숫자, 4~20자)
	usernameRegex := `^[a-zA-Z0-9]{4,20}$`
	if !matchRegex(usernameRegex, input.Username) {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Username must be 4-20 characters long, containing only letters and numbers",
		})
	}

	// 비밀번호 검증 (12자 이상, 숫자+특수문자 포함)
	if !isValidPassword(input.Password) {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Password must be at least 12 characters long, containing letters, numbers, and special characters",
		})
	}

	// 토큰 생성
	hashedPassword := authority.HashPassword(input.Password)
	timestamp := fmt.Sprintf("%d", time.Now().UnixNano()/int64(time.Millisecond))
	randomValue := fmt.Sprintf("%d", time.Now().UnixNano()/int64(time.Microsecond))
	tokenInput := input.Username + ":" + timestamp + ":" + randomValue
	hash := sha256.Sum256([]byte(tokenInput))
	token := hex.EncodeToString(hash[:])

	// `model.Admin`을 사용해야 함 (helper.AdminModel 없음)
	admin := &model.Admin{
		Username: input.Username,
		Password: hashedPassword,
		Token:    token,
		IsActive: true,
	}

	// DB에 저장
	if err := config.DB.Create(&admin).Error; err != nil {
		log.Println("Error creating admin:", err)
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Failed to create admin",
		})
	}

	return c.Status(fiber.StatusCreated).JSON(fiber.Map{
		"message": "🎉 Admin created successfully! Store the token safely.",
		"data": fiber.Map{
			"id":       admin.ID,
			"username": admin.Username,
			"token":    admin.Token,
		},
	})
}

// 정규식 검사 함수
func matchRegex(pattern, input string) bool {
	re := regexp.MustCompile(pattern)
	return re.MatchString(input)
}

func isValidPassword(password string) bool {
	// ✅ 기본 길이 검사 (12자 이상)
	if len(password) < 12 {
		log.Println("❌ Password too short")
		return false
	}

	// ✅ 숫자 포함 검사
	hasNumber, _ := regexp.MatchString(`[0-9]`, password)
	// ✅ 특수문자 포함 검사
	hasSpecialChar, _ := regexp.MatchString(`[@$!%*#?&]`, password)
	// ✅ 영문 포함 검사
	hasLetter, _ := regexp.MatchString(`[A-Za-z]`, password)

	if !hasNumber || !hasSpecialChar || !hasLetter {
		log.Println("❌ Password must contain letters, numbers, and special characters")
		return false
	}

	return true
}
