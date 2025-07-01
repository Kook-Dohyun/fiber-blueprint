package routes

import (
	"fiber_server/routes/middleware"
	"fiber_server/routes/middleware/authority"

	"github.com/gofiber/fiber/v3"
)

// 라우트 설정 함수
func SetupRoutes(app *fiber.App) {

	app.Use(func(c fiber.Ctx) error {
		return authority.ValidatePepper(c)
	})
	app.Use(func(c fiber.Ctx) error {
		middleware.ParamsLogger(c)
		return c.Next()
	})

	// 각 엔드포인트 라우트 등록
	SetupAdminRoutes(app)
	SetupWalletRoutes(app)
	SetupPersonaRoutes(app)
	SetupPersonaSubscribeRoutes(app)
	SetupPersonaProfileRoutes(app)
	SetupPersonaBackgroundMediaRoutes(app)
	SetupHomeFeedRoutes(app)
	SetupPostRoutes(app)
	SetupConnectionRoutes(app)
	SetupChatRoutes(app)
	SetupNotificationRoutes(app)
}
