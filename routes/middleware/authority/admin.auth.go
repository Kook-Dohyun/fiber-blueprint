package authority

import (
	// "errors"

	"fiber_server/config"
	"fiber_server/model"
	"fmt"
	"log"
	"sync"
	"time"

	"github.com/gofiber/fiber/v3"
	"gorm.io/gorm"
)

// 관리자 전용 Pepper 값 (비밀번호 보안용)
const prodaoPepper = "0af6d35fb917354a7ddf5c67bba67436383a6dc1bf8c50f3ecab5a0f1f1fc5f6"

// 블랙리스트 및 실패 카운트를 위한 저장소
var (
	blacklist    = make(map[string]time.Time) // 블랙리스트 (IP+User-Agent)
	failedCounts = make(map[string]int)       // 실패 카운트 (IP+User-Agent)
	mu           sync.Mutex                   // 동시 접근 제어
)

// 🔐 Pepper 검증 및 블랙리스트 처리 미들웨어
func ValidatePepper(c fiber.Ctx) error {
	ip := c.IP()
	userAgent := c.Get("User-Agent")
	clientKey := generateClientKey(ip, userAgent)

	mu.Lock()
	defer mu.Unlock()

	// 🚫 블랙리스트 확인 (힌트 없는 처리)
	if expiry, blocked := blacklist[clientKey]; blocked {
		if time.Now().Before(expiry) {
			log.Printf("🚫 차단된 클라이언트 접근 시도: %s (남은 시간: %v)", clientKey, time.Until(expiry))
			return c.Status(fiber.StatusForbidden).JSON(fiber.Map{"error": "Access denied"})
		}
		// 차단 기간 종료 시 블랙리스트 해제
		delete(blacklist, clientKey)
		log.Printf("✅ 차단 해제된 클라이언트: %s", clientKey)
	}

	// 🔑 Pepper 검증
	return checkPepper(c, clientKey)
}

// 🔑 Pepper 검증 로직 (힌트 없는 반환)
func checkPepper(c fiber.Ctx, clientKey string) error {
	requestPepper := c.Get("X-Prodao-Pepper")
	loggerMiddeleware(c)
	// ✅ 올바른 Pepper일 경우
	if requestPepper == prodaoPepper {
		delete(failedCounts, clientKey) // 성공 시 실패 카운트 초기화
		return c.Next()
	}

	// 🚨 실패 카운트 증가 및 차단 처리
	failedCounts[clientKey]++
	log.Printf("❌ Invalid Pepper from Client: %s (실패 %d회)", clientKey, failedCounts[clientKey])

	// ⚠️ 3회 실패 시 1시간 차단 (클라이언트에 차단 정보 제공 X)
	if failedCounts[clientKey] >= 3 {
		blacklist[clientKey] = time.Now().Add(1 * time.Hour)
		delete(failedCounts, clientKey)
		log.Printf("🚫 클라이언트 차단: %s", clientKey)
		return c.Status(fiber.StatusForbidden).JSON(fiber.Map{"error": "Access denied"})
	}

	// 🚫 실패 시 힌트 없는 403 반환
	return c.Status(fiber.StatusForbidden).JSON(fiber.Map{"error": "Access denied"})
}

// 🔑 클라이언트 키 생성 (IP + User-Agent 기반)
func generateClientKey(ip, userAgent string) string {
	return fmt.Sprintf("%s|%s", ip, userAgent)
}
func loggerMiddeleware(c fiber.Ctx) {
	ip := c.IP()
	if ip == "49.167.155.5" || ip == "127.0.0.1" { // 🚫 특정 IP만 로그 생성안함
		return
	}
	// 헤더 정보에서 IP 등 모든 헤더 정보를 추출하여 로그에 출력
	headers := c.GetReqHeaders()
	for key, value := range headers {
		log.Printf("Header: %s = %s\n", key, value)
	}
	log.Println("📡 c.IP():", c.IP())

}

// 🔐 관리자 인증 미들웨어
func CheckAdminAuth(c fiber.Ctx) bool {

	token, e := ExtractBaererHeader(c)
	if e != nil {
		log.Println(e)
		return false
	}
	password := c.Get("Password")

	log.Println("🔑 Received Authorization Header:", token)
	log.Println("🔑 Received Password Header:", password)

	if token == "" || password == "" {
		log.Println("❌ Missing or invalid Authorization/Password headers")
		return false
	}

	hashedPassword := HashPassword(password)

	log.Println("🔑 Extracted Token:", token)
	log.Println("🔑 Hashed Password:", hashedPassword)

	// 🔍 GORM 쿼리 실행 전 확인
	log.Println("🛠 Running GORM Query with conditions:")
	log.Println("   ➤ Token:", token)
	log.Println("   ➤ Hashed Password:", hashedPassword)
	log.Println("   ➤ Active Status: true")

	// 🔹 ORM 방식으로 쿼리 실행
	var admin model.Admin
	err := config.DB.Model(&model.Admin{}).
		Where("token = ? AND password = ? AND is_active = ?", token, hashedPassword, true).
		First(&admin).Error

	// 🔍 GORM 쿼리 결과 확인
	if err != nil {
		if err == gorm.ErrRecordNotFound {
			log.Println("❌ Admin authentication failed: No matching record found")
			return false
		}
		log.Println("❌ Database query error:", err)
		return false
	}

	log.Println("✅ Admin authentication successful")
	return true
}
