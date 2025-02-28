package config

import (
	"fmt"
	"log"
	"os"
	"strconv"
	"time"
)

type Config struct {
	Database DatabaseConfig
	Firebase FirebaseConfig
	Server   ServerConfig
}

type DatabaseConfig struct {
	Host           string
	User           string
	Password       string
	DBName         string
	Port           string
	SSLMode        string
	TimeZone       string
	ConnectTimeout int

	// API DB 커넥션 풀 설정
	MaxOpenConns    int
	MaxIdleConns    int
	ConnMaxLifetime time.Duration
	ConnMaxIdleTime time.Duration

	// Chat DB 커넥션 풀 설정
	ChatMaxOpenConns    int
	ChatMaxIdleConns    int
	ChatConnMaxLifetime time.Duration
	ChatConnMaxIdleTime time.Duration
}

type FirebaseConfig struct {
	CredentialsPath string
}

type ServerConfig struct {
	Port string
	Env  string
}

var AppConfig *Config

// LoadConfig 설정 로드
func LoadConfig() {
	AppConfig = &Config{
		Database: DatabaseConfig{
			Host:           getEnv("DB_HOST", "localhost"),
			User:           getEnv("DB_USER", "postgres"),
			Password:       getEnv("DB_PASSWORD", "postgres"),
			DBName:         getEnv("DB_NAME", "prodao_v2"),
			Port:           getEnv("DB_PORT", "5432"),
			SSLMode:        getEnv("DB_SSLMODE", "disable"),
			TimeZone:       getEnv("DB_TIMEZONE", "UTC"),
			ConnectTimeout: getEnvAsInt("DB_CONNECT_TIMEOUT", 10),

			// API DB 설정
			MaxOpenConns:    getEnvAsInt("DB_MAX_OPEN_CONNS", 1000),
			MaxIdleConns:    getEnvAsInt("DB_MAX_IDLE_CONNS", 100),
			ConnMaxLifetime: getEnvAsDuration("DB_CONN_MAX_LIFETIME", "1m"),
			ConnMaxIdleTime: getEnvAsDuration("DB_CONN_MAX_IDLE_TIME", "10s"),

			// Chat DB 설정
			ChatMaxOpenConns:    getEnvAsInt("CHAT_DB_MAX_OPEN_CONNS", 800),
			ChatMaxIdleConns:    getEnvAsInt("CHAT_DB_MAX_IDLE_CONNS", 50),
			ChatConnMaxLifetime: getEnvAsDuration("CHAT_DB_CONN_MAX_LIFETIME", "5m"),
			ChatConnMaxIdleTime: getEnvAsDuration("CHAT_DB_CONN_MAX_IDLE_TIME", "1m"),
		},
		Firebase: FirebaseConfig{
			CredentialsPath: getEnv("FIREBASE_CREDENTIALS_PATH", "config/firebase-credential.json"),
		},
		Server: ServerConfig{
			Port: getEnv("SERVER_PORT", "8080"),
			Env:  getEnv("APP_ENV", "development"),
		},
	}

	log.Println("✅ 설정 로드 완료")
}

// GetDSN 데이터베이스 DSN 생성
func (c *Config) GetDSN() string {
	return fmt.Sprintf("host=%s user=%s password=%s dbname=%s port=%s sslmode=%s TimeZone=%s connect_timeout=%d",
		c.Database.Host,
		c.Database.User,
		c.Database.Password,
		c.Database.DBName,
		c.Database.Port,
		c.Database.SSLMode,
		c.Database.TimeZone,
		c.Database.ConnectTimeout,
	)
}

// 헬퍼 함수들
func getEnv(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}

func getEnvAsInt(key string, defaultValue int) int {
	if value := os.Getenv(key); value != "" {
		if intValue, err := strconv.Atoi(value); err == nil {
			return intValue
		}
	}
	return defaultValue
}

func getEnvAsDuration(key string, defaultValue string) time.Duration {
	if value := os.Getenv(key); value != "" {
		if duration, err := time.ParseDuration(value); err == nil {
			return duration
		}
	}
	duration, _ := time.ParseDuration(defaultValue)
	return duration
}
