package model

import (
	"encoding/json"
	"time"

	"database/sql/driver"
	"errors"
)

const (
	TableNameNotificationPreference = "notification_preference"
	TableNameGlobalNotification     = "global_notification"
	TableNamePersonaNotification    = "persona_notification"
	// TimeFormatISO8601 : ISO 8601 형식의 시간 포맷
	TimeFormatISO8601 = "2006-01-02T15:04:05.000Z"
	// TimeFormatTimeOnly : 시간만 표시하는 포맷
	TimeFormatTimeOnly = "15:04"
)

// NotificationType : 알림 타입 정의
type NotificationType string

const (
	NotificationTypeMessage     NotificationType = "message"
	NotificationTypeChat        NotificationType = "chat"
	NotificationTypeCall        NotificationType = "call"
	NotificationTypeTransaction NotificationType = "transaction"
	NotificationTypePost        NotificationType = "post"
	NotificationTypeComment     NotificationType = "comment"
	NotificationTypeLike        NotificationType = "like"
	NotificationTypeFollow      NotificationType = "follow"
	NotificationTypeMention     NotificationType = "mention"
	NotificationTypeSystem      NotificationType = "system"
	NotificationTypeProposal    NotificationType = "proposal"
	NotificationTypeDAO         NotificationType = "dao"
	NotificationTypeVote        NotificationType = "vote"
)

const (
	ActionNavigateToPage      = "navigate_to_page"      // 페이지로 이동
	ActionOpenURL             = "open_url"              // URL 열기
	ActionOpenApp             = "open_app"              // 앱 열기
	ActionOpenChat            = "open_chat"             // 채팅 열기
	ActionOpenTransaction     = "open_transaction"      // 거래 열기
	ActionOpenPost            = "open_post"             // 포스트 열기
	ActionOpenComment         = "open_comment"          // 댓글 열기
	ActionOpenLike            = "open_like"             // 좋아요 열기
	ActionOpenFollow          = "open_follow"           // 팔로우 열기
	ActionOpenMention         = "open_mention"          // 멘션 열기
	ActionOpenSystem          = "open_system"           // 시스템 알림 열기
	ActionOpenProposal        = "open_proposal"         // 제안 열기
	ActionOpenDAO             = "open_dao"              // DAO 알림 열기
	ActionOpenVote            = "open_vote"             // 투표 열기
	ActionOpenNotification    = "open_notification"     // 알림 열기
	ActionOpenSettings        = "open_settings"         // 설정 열기
	ActionOpenProfile         = "open_profile"          // 프로필 열기
	ActionOpenWallet          = "open_wallet"           // 지갑 열기
	ActionOpenPersona         = "open_persona"          // 페르소나 열기
	ActionOpenChatList        = "open_chat_list"        // 채팅 목록 열기
	ActionOpenTransactionList = "open_transaction_list" // 거래 목록 열기
	ActionOpenPostList        = "open_post_list"        // 포스트 목록 열기
	ActionOpenCommentList     = "open_comment_list"     // 댓글 목록 열기
	ActionOpenLikeList        = "open_like_list"        // 좋아요 목록 열기
	ActionOpenFollowList      = "open_follow_list"      // 팔로우 목록 열기
	ActionOpenMentionList     = "open_mention_list"     // 멘션 목록 열기
	ActionOpenSystemList      = "open_system_list"      // 시스템 알림 목록 열기
	ActionOpenProposalList    = "open_proposal_list"    // 제안 목록 열기
	ActionOpenDAOList         = "open_dao_list"         // DAO 알림 목록 열기
	ActionOpenVoteList        = "open_vote_list"        // 투표 목록 열기
	ActionOpenSettingsList    = "open_settings_list"    // 설정 목록 열기
	ActionOpenProfileList     = "open_profile_list"     // 프로필 목록 열기

)

// getDefaultExpirationTime : NotificationType에 따라 기본 만료일자를 설정
func GetDefaultExpirationTime(notificationType NotificationType) *time.Time {
	var defaultDuration time.Duration

	switch notificationType {
	case NotificationTypeMessage:
		defaultDuration = 1 * time.Hour // 메시지의 경우 1시간 후
	case NotificationTypeChat:
		defaultDuration = 12 * time.Hour // 채팅의 경우 12시간 후
	case NotificationTypeCall:
		defaultDuration = 30 * time.Minute // 통화의 경우 30분 후
	case NotificationTypeTransaction:
		defaultDuration = 24 * time.Hour // 거래의 경우 24시간 후
	case NotificationTypePost:
		defaultDuration = 6 * time.Hour // 포스트의 경우 6시간 후
	case NotificationTypeComment:
		defaultDuration = 2 * time.Hour // 댓글의 경우 2시간 후
	case NotificationTypeLike:
		defaultDuration = 1 * time.Hour // 좋아요의 경우 1시간 후
	case NotificationTypeFollow:
		defaultDuration = 24 * time.Hour // 팔로우의 경우 24시간 후
	case NotificationTypeMention:
		defaultDuration = 1 * time.Hour // 멘션의 경우 1시간 후
	case NotificationTypeSystem:
		defaultDuration = 48 * time.Hour // 시스템 알림의 경우 48시간 후
	case NotificationTypeProposal:
		defaultDuration = 72 * time.Hour // 제안의 경우 72시간 후
	case NotificationTypeDAO:
		defaultDuration = 24 * time.Hour // DAO 알림의 경우 24시간 후
	case NotificationTypeVote:
		defaultDuration = 24 * time.Hour // 투표의 경우 24시간 후
	default:
		defaultDuration = 24 * time.Hour // 기본값: 24시간 후
	}

	expirationTime := time.Now().Add(defaultDuration)
	return &expirationTime
}

// NotificationSound : 알림 사운드 정의
type NotificationSound string

const (
	NotificationSoundDefault NotificationSound = "default"
	NotificationSoundMessage NotificationSound = "message"
	NotificationSoundSystem  NotificationSound = "system"
)

// NotificationPriority : 알림 우선순위 정의
type NotificationPriority string

const (
	NotificationPriorityHigh   NotificationPriority = "high"
	NotificationPriorityNormal NotificationPriority = "normal"
	NotificationPriorityLow    NotificationPriority = "low"
)

// NotificationTypeSettings : 알림 타입별 설정 구조체
type NotificationTypeSettings struct {
	Enabled  bool                 `json:"enabled"`
	Sound    NotificationSound    `json:"sound"`
	Priority NotificationPriority `json:"priority"`
}

// NotificationTypes : 알림 타입별 설정 맵
type NotificationTypes map[NotificationType]NotificationTypeSettings

// TimeString : 시간 문자열 타입
type TimeString string

// QuietHoursSettings : 조용한 시간 설정
type QuietHoursSettings struct {
	Enabled    bool               `json:"enabled"`
	StartTime  TimeString         `json:"start_time"`
	EndTime    TimeString         `json:"end_time"`
	Exceptions []NotificationType `json:"exceptions"`
}

// NotificationGrouping : 알림 그룹화 설정 구조체
type NotificationGrouping struct {
	Enabled  bool   `json:"enabled"`
	GroupBy  string `json:"group_by"` // type, sender, none
	Collapse bool   `json:"collapse"`
}

// NotificationGlobalSettings : Wallet 레벨 알림 설정
type NotificationGlobalSettings struct {
	NotificationTypes NotificationTypes    `json:"notification_types"`
	QuietHours        QuietHoursSettings   `json:"quiet_hours"`
	Grouping          NotificationGrouping `json:"grouping"`
}

// Scan implements the sql.Scanner interface for NotificationGlobalSettings
func (n *NotificationGlobalSettings) Scan(value interface{}) error {
	if value == nil {
		return nil
	}
	bytes, ok := value.([]byte)
	if !ok {
		return errors.New("failed to scan NotificationGlobalSettings")
	}
	return json.Unmarshal(bytes, n)
}

// Value implements the driver.Valuer interface for NotificationGlobalSettings
func (n NotificationGlobalSettings) Value() (driver.Value, error) {
	return json.Marshal(n)
}

// NotificationPersonaSettings : 페르소나 레벨 알림 설정
type NotificationPersonaSettings struct {
	NotificationTypes NotificationTypes    `json:"notification_types"`
	QuietHours        QuietHoursSettings   `json:"quiet_hours"`
	Grouping          NotificationGrouping `json:"grouping"`
}

// Scan implements the sql.Scanner interface for NotificationPersonaSettings
func (n *NotificationPersonaSettings) Scan(value interface{}) error {
	if value == nil {
		return nil
	}
	bytes, ok := value.([]byte)
	if !ok {
		return errors.New("failed to scan NotificationPersonaSettings")
	}
	return json.Unmarshal(bytes, n)
}

// Value implements the driver.Valuer interface for NotificationPersonaSettings
func (n NotificationPersonaSettings) Value() (driver.Value, error) {
	return json.Marshal(n)
}

// NotificationPreference : Wallet의 알림 설정 모델
type NotificationPreference struct {
	ID             string                     `gorm:"column:id;primaryKey;type:text;default:uuid_generate_v4()" json:"id"`
	WalletDID      string                     `gorm:"column:wallet_did;not null" json:"wallet_did"`
	FCMToken       string                     `gorm:"column:fcm_token" json:"fcm_token,omitempty"`               // APNS Token or FCM Token
	DeviceType     string                     `gorm:"column:device_type;type:text" json:"device_type,omitempty"` // android, ios, macos, web
	IsEnabled      bool                       `gorm:"column:is_enabled;not null;default:true" json:"is_enabled"`
	GlobalSettings NotificationGlobalSettings `gorm:"column:global_settings;type:jsonb" json:"global_settings"`
	CreatedAt      time.Time                  `gorm:"column:created_at;not null;autoCreateTime" json:"created_at"`
	UpdatedAt      time.Time                  `gorm:"column:updated_at;not null;autoUpdateTime" json:"updated_at"`

	// Relations
	PersonaPreferences []PersonaNotificationPreference `gorm:"foreignKey:PreferenceID" json:"persona_preferences,omitempty"`
	Wallet             *Wallet                         `gorm:"foreignKey:wallet_did;references:did" json:"wallet,omitempty"`
}

// Scan implements the sql.Scanner interface for NotificationPreference
func (n *NotificationPreference) Scan(value interface{}) error {
	if value == nil {
		return nil
	}
	bytes, ok := value.([]byte)
	if !ok {
		return errors.New("failed to scan NotificationPreference")
	}
	return json.Unmarshal(bytes, n)
}

// Value implements the driver.Valuer interface for NotificationPreference
func (n NotificationPreference) Value() (driver.Value, error) {
	return json.Marshal(n)
}

// GlobalNotification : Wallet 레벨 알림 모델
type GlobalNotification struct {
	ID        string                 `gorm:"column:id;primaryKey;type:text;default:uuid_generate_v4()" json:"id"`
	WalletDID string                 `gorm:"column:wallet_did;not null" json:"wallet_did"`
	Type      string                 `gorm:"column:type;not null" json:"type"` // "GLOBAL", "SYSTEM", etc.
	Title     string                 `gorm:"column:title;not null" json:"title"`
	Content   string                 `gorm:"column:content;not null" json:"content"`
	Data      map[string]interface{} `gorm:"column:data;type:jsonb" json:"data"` // Additional data in JSON format
	CreatedAt time.Time              `gorm:"column:created_at;not null;autoCreateTime" json:"created_at"`
	ExpiresAt *time.Time             `gorm:"column:expires_at" json:"expires_at,omitempty"`
	Priority  int                    `gorm:"column:priority;default:0" json:"priority"` // 0: normal, 1: high

	// Relations
	Wallet *Wallet `gorm:"foreignKey:wallet_did;references:did" json:"wallet,omitempty"`
}

// PersonaNotification : 페르소나 알림 모델
type PersonaNotification struct {
	ID        string                 `gorm:"column:id;primaryKey;type:text;default:uuid_generate_v4()" json:"id"`
	PersonaID string                 `gorm:"column:persona_id;not null" json:"persona_id"`
	Type      string                 `gorm:"column:type;not null" json:"type"` // "POST", "COMMENT", "MESSAGE", etc.
	Title     string                 `gorm:"column:title;not null" json:"title"`
	Content   string                 `gorm:"column:content;not null" json:"content"`
	Data      map[string]interface{} `gorm:"column:data;type:jsonb" json:"data"` // Additional data in JSON format
	CreatedAt time.Time              `gorm:"column:created_at;not null;autoCreateTime" json:"created_at"`
	ExpiresAt *time.Time             `gorm:"column:expires_at" json:"expires_at,omitempty"`
	Priority  int                    `gorm:"column:priority;default:0" json:"priority"` // 0: normal, 1: high

	// Relations
	Persona *Persona `gorm:"foreignKey:persona_id;references:id" json:"persona,omitempty"`
}

// TableName returns the table name for each model
func (*NotificationPreference) TableName() string {
	return TableNameNotificationPreference
}

func (*GlobalNotification) TableName() string {
	return TableNameGlobalNotification
}

func (*PersonaNotification) TableName() string {
	return TableNamePersonaNotification
}
