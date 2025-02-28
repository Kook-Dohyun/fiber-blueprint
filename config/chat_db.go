package config

import (
	"log"
	"time"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"gorm.io/gorm/schema"
)

var ChatDB *gorm.DB

func ConnectChatDB() (*gorm.DB, error) {
	dsn := "host=localhost user=postgres password=postgres dbname=prodao_v2 port=5432 sslmode=disable TimeZone=UTC connect_timeout=10"

	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{
		NamingStrategy: schema.NamingStrategy{
			SingularTable: true,
		},
		NowFunc: func() time.Time {
			return time.Now().UTC()
		},
		// 채팅 전용 설정 추가
		PrepareStmt: true, // Statement 캐싱
	})

	if err != nil {
		log.Printf("❌ 채팅 데이터베이스 연결 실패: %v", err)
		return nil, err
	}

	sqlDB, err := db.DB()
	if err != nil {
		return nil, err
	}

	// 채팅용 커넥션 풀 설정
	sqlDB.SetMaxOpenConns(800)                // 구독 연결용 적은 수의 커넥션
	sqlDB.SetMaxIdleConns(50)                 // 유휴 연결 제한
	sqlDB.SetConnMaxLifetime(5 * time.Minute) // 연결 수명 증가 (구독 연결 유지)
	sqlDB.SetConnMaxIdleTime(1 * time.Minute) // 유휴 시간 증가

	log.Println("✅ 채팅 데이터베이스 연결 및 구독용 커넥션 풀 설정 완료")

	return db, nil
}
