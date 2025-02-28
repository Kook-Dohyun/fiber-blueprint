package config

import (
	"log"
	"time"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"gorm.io/gorm/schema"
)

var DB *gorm.DB

func ConnectDB() (*gorm.DB, error) {
	dsn := AppConfig.GetDSN()
	/* dsn := "host=localhost user=postgres password=postgres dbname=prodao_v2 port=5432 sslmode=disable TimeZone=UTC connect_timeout=10"
	dsn = "host=prodao-serverless.cluster-ro-cxewauw2opm6.ap-northeast-2.rds.amazonaws.com user=postgres password=<DB_PASS_WORD> dbname=prodao port=5432 sslmode=disable TimeZone=UTC connect_timeout=20" */
	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{
		NamingStrategy: schema.NamingStrategy{
			SingularTable: true, // 테이블 이름을 단수형으로 유지
		},
		NowFunc: func() time.Time {
			return time.Now().UTC()
		},
	})

	if err != nil {
		log.Printf("❌ 데이터베이스 연결 실패: %v", err)
		return nil, err
	}

	// ✅ 커넥션 풀 설정 (최적화된 설정)
	// 커넥션 풀 설정
	sqlDB, err := db.DB()
	if err != nil {
		return nil, err
	}

	// 1. 최대 연결 수 (2000개 중 분산 운영)
	sqlDB.SetMaxOpenConns(AppConfig.Database.MaxOpenConns)       // 동시 연결 제한 (1000개)
	sqlDB.SetMaxIdleConns(AppConfig.Database.MaxIdleConns)       // 유휴 연결 제한 (동시 요청이 적을 때 유지하는 커넥션 수)
	sqlDB.SetConnMaxLifetime(AppConfig.Database.ConnMaxLifetime) // 연결 수명 (1분 뒤 재생성)
	sqlDB.SetConnMaxIdleTime(AppConfig.Database.ConnMaxIdleTime) // 유휴 연결 최대 시간 (10초 후 종료)
	log.Println("✅ 데이터베이스 연결 및 커넥션 풀 설정 완료")

	return db, nil
}
