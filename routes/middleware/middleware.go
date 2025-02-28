package middleware

import (
	"encoding/json"
	"log"

	"github.com/gofiber/fiber/v3"
)

// func DBConnect(c fiber.Ctx) error {
// 	config.ConnectDB() // 요청 시 DB 연결
// 	defer func() {
// 		log.Println("🔒 DB 연결 종료")
// 		sqlDB, _ := config.DB.DB()
// 		sqlDB.Close() // 요청 종료 시 DB 종료
// 	}()
// 	return c.Next() // 다음 미들웨어 또는 핸들러로 전달
// }

func ParamsLogger(c fiber.Ctx) { // TODO:배포시 제거.
	// 요청 메서드와 경로 로깅
	log.Printf("🔍 Method: %s, Path: %s", c.Method(), c.Path())

	// 1️⃣ Query 파라미터 로깅
	if queries := c.Queries(); len(queries) > 0 {
		log.Printf("📝 Query Parameters: %v", queries)
	}
}

func WalletParamsLogger(c fiber.Ctx) error {

	// 1️⃣ URL Path 파라미터 로깅
	paramNames := c.Route().Params
	if len(paramNames) > 0 {
		params := make(map[string]string)
		for _, param := range paramNames {
			params[param] = c.Params(param)
		}
		log.Printf("🔖 URL Path Parameters: %v", params)
	}

	// 2️⃣ Body 데이터 로깅 (POST, PUT 요청에서)
	if c.Method() == "POST" || c.Method() == "PUT" {
		var body map[string]interface{}
		bodyBytes := c.Body()
		if len(bodyBytes) > 0 {
			if err := json.Unmarshal(bodyBytes, &body); err == nil {
				log.Printf("📦 Body Parameters: %v", body)
			} else {
				log.Printf("❌ Failed to parse body: %v", err)
			}
			// Body를 다시 설정하여 다음 핸들러에서 사용할 수 있도록 함
			c.Request().SetBody(bodyBytes)
		}
	}

	return c.Next()
}
