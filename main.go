package main

import (
	"fiber_server/config"
	"fiber_server/routes"
	"fiber_server/utils"
	"log"
	"os"
	"runtime"

	"github.com/gofiber/fiber/v3"
)

func main() {
	// 현재 사용 가능한 CPU 개수를 가져옴
	numCPU := runtime.NumCPU()
	log.Printf("🖥️ 사용 가능한 CPU 개수: %d", numCPU)

	// 모든 CPU 코어를 사용하도록 설정
	runtime.GOMAXPROCS(numCPU)

	// 설정 로드
	config.LoadConfig()

	// DB 연결 및 초기화
	db, err := config.ConnectDB()
	if err != nil {
		log.Fatalf("❌ 데이터베이스 연결 실패: %v", err)
	}
	config.DB = db // 반환된 DB 인스턴스를 전역 변수에 할당

	db, err = config.ConnectChatDB()
	if err != nil {
		log.Fatalf("❌ 채팅 데이터베이스 연결 실패: %v", err)
	}
	config.ChatDB = db // 반환된 DB 인스턴스를 전역 변수에 할당

	log.Println("✅ 데이터베이스 연결 및 커넥션 풀 설정 완료")

	// Firebase 초기화
	utils.InitFirebaseApp()
	log.Println("✅ Firebase 클라이언트 초기화 완료")

	// Fiber 인스턴스 생성 (기본 설정 사용)
	app := fiber.New(
		fiber.Config{
			ServerHeader: "PRODAO_V2",
		},
	)

	// 라우트 설정 추가
	routes.SetupRoutes(app) // 🔹 전체 라우트 설정 적용

	// 포트 설정
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	log.Printf("🚀 서버 실행 중: http://localhost:%s", port)
	log.Fatal(app.Listen("0.0.0.0:" + port))
}
