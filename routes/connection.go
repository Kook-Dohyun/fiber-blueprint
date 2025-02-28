package routes

import (
	"fiber_server/config"
	"log"

	"github.com/gofiber/fiber/v3"
)

func SetupConnectionRoutes(app *fiber.App) {
	connectionGroup := app.Group("/connection")
	connectionGroup.Get("/", getConnectionStatus)
}

// getConnectionStatus : DB 연결 상태 및 커넥션 풀 정보 조회
func getConnectionStatus(c fiber.Ctx) error {
	if config.DB == nil {
		log.Println("db instance is nil")
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "cannot connect to database",
		})
	}

	// DB 연결 정보 가져오기
	sqlDB, err := config.DB.DB()
	if err != nil {
		log.Println("❌ DB 연결 정보 가져오기 실패:", err)
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "cannot connect to database",
		})
	}

	// 커넥션 풀 상태 확인
	stats := sqlDB.Stats()

	return c.JSON(fiber.Map{
		"message": "db connection status",
		"db_connection": fiber.Map{
			"MaxOpenConnections": stats.MaxOpenConnections,
			"OpenConnections":    stats.OpenConnections,
			"InUse":              stats.InUse,
			"Idle":               stats.Idle,
			"WaitCount":          stats.WaitCount,
			"WaitDuration":       stats.WaitDuration.String(),
			"MaxIdleClosed":      stats.MaxIdleClosed,
			"MaxLifetimeClosed":  stats.MaxLifetimeClosed,
		},
	})
}
