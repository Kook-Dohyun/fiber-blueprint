# 📁 Fiber Server 프로젝트 파일 구조
language: go lang
framework: gofiber/fiber/v3
ORM: gorm 

이 문서는 `fiber_server` 프로젝트의 파일 및 폴더 구조를 설명하며, 각 파일의 역할을 명확히 정의합니다.

---

## 🏗 프로젝트 개요
`fiber_server`는 **Go Fiber**를 기반으로 구축된 서버 애플리케이션입니다. PostgreSQL을 사용하며, `gorm/gen`을 통해 데이터 모델을 자동 생성하고 관리합니다.

---

## 📂 프로젝트 구조
```
 fiber_server
 ├── .env                  # 환경 변수 파일
 ├── go.mod                # Go 모듈 관리 파일
 ├── go.sum                # 모듈 종속성 해시 값
 ├── main.go               # Fiber 서버 실행 파일
 ├── README.md             # 프로젝트 설명서
 │
 ├── config/               # 환경 변수 및 DB 설정 관련 패키지
 │   ├── config.go         # DB 연결 및 환경 변수 로드
 │
 ├── database/             # DB 모델 생성 및 마이그레이션 관리
 │   ├── gen_models.go     # GORM 모델 자동 생성 스크립트
 │   ├── migrate.go        # 마이그레이션 실행 파일 (main 패키지)
 │   ├── migration.md      # 마이그레이션 관련 문서
 │
 ├── helper/               # GORM Query 인터페이스 자동 생성 파일
 │   ├── gen.go            # GORM 자동 생성 엔트리 파일
 │   ├── admin.gen.go      # Admin 테이블 쿼리 인터페이스
 │   ├── wallet.gen.go     # Wallet 테이블 쿼리 인터페이스
 │   ├── ...               # 기타 테이블의 자동 생성된 쿼리 인터페이스
 │
 ├── model/                # GORM 모델 구조체 자동 생성 파일
 │   ├── admin.gen.go      # Admin 모델 구조체 정의
 │   ├── wallet.gen.go     # Wallet 모델 구조체 정의
 │   ├── ...               # 기타 테이블의 모델 구조체 정의
 │
 ├── routes/               # Fiber 라우트 정의
 │   ├── admin.go          # Admin 관련 라우트 핸들러
 │   ├── persona.go        # Persona 관련 라우트 핸들러
 │   ├── routes.go         # 전체 라우트 설정
```

---

## 📌 상세 설명

### **1️⃣ `config/`**
- `config.go` : 환경 변수를 로드하고 DB 연결을 설정하는 파일.

### **2️⃣ `database/`**
- `gen_models.go` : `gorm/gen`을 사용하여 데이터 모델을 자동 생성하는 스크립트.
- `migrate.go` : 마이그레이션을 실행하는 파일 (`go run database/migrate.go` 실행).
- `migration.md` : 마이그레이션 관련 문서.

### **3️⃣ `helper/`**
- `gen.go` : `gorm/gen` 설정 및 실행 파일.
- `{table}.gen.go` : GORM Query 인터페이스 자동 생성 파일.

### **4️⃣ `model/`**
- `{table}.gen.go` : GORM 데이터 모델 자동 생성 파일.

### **5️⃣ `routes/`**
- `routes.go` : 전체 라우트를 설정하는 파일.
- `{resource}.go` : 특정 엔드포인트를 처리하는 핸들러.

---

## 🚀 실행 방법
### **1️⃣ 서버 실행**
```sh
$ go run main.go
```
### **2️⃣ 마이그레이션 실행**
```sh
$ go run database/migrate.go
```

---

## 📌 추가 정보
- **Fiber 기반의 서버**이며, `gorm`을 사용하여 데이터베이스를 관리합니다.
- **모델 및 쿼리 인터페이스 자동 생성** (`gorm/gen`)을 활용하여 유지보수를 쉽게 할 수 있습니다.
- **서버 실행과 마이그레이션 로직을 분리**하여 유지보수가 용이합니다.

