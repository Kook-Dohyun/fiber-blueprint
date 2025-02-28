package authority

import (
	"crypto/sha256"
	"encoding/hex"
	"errors"
	"log"
	"strings"

	"github.com/gofiber/fiber/v3"
)

// ✅ 헤더에서 토큰 추출
func ExtractBaererHeader(c fiber.Ctx) (string, error) {
	authHeader := c.Get("Authorization")
	if authHeader == "" || !strings.HasPrefix(authHeader, "Bearer ") {
		return "", errors.New("인증 토큰이 없습니다")
	}
	return strings.TrimPrefix(authHeader, "Bearer "), nil
}

// 🔐 비밀번호 해싱 함수 (SHA-256)
func HashPassword(password string) string {
	// ✅ Dart Frog에서 사용한 방식 확인 후 동일한 해싱 적용
	hash := sha256.Sum256([]byte(password)) // 🔹 `prodaoPepper` 제거
	hashedPassword := hex.EncodeToString(hash[:])

	// 🔍 디버깅 로그 추가
	log.Println("🔑 Debug: Hashed Password Output:", hashedPassword)
	return hashedPassword
}
