package model

import (
	"time"
)

const TableNamePersonaNotificationPreference = "persona_notification_preference"

// PersonaNotificationPreference : 페르소나 알림 설정 모델
type PersonaNotificationPreference struct {
	ID              string                      `gorm:"column:id;primaryKey;type:text;default:uuid_generate_v4()" json:"id"`
	PreferenceID    string                      `gorm:"column:preference_id;not null" json:"preference_id"`
	PersonaID       string                      `gorm:"column:persona_id;not null" json:"persona_id"`
	IsEnabled       bool                        `gorm:"column:is_enabled;not null;default:true" json:"is_enabled"`
	PersonaSettings NotificationPersonaSettings `gorm:"column:persona_settings;type:jsonb" json:"persona_settings"`
	CreatedAt       time.Time                   `gorm:"column:created_at;not null;autoCreateTime" json:"created_at"`
	UpdatedAt       time.Time                   `gorm:"column:updated_at;not null;autoUpdateTime" json:"updated_at"`

	// Relations
	Preference *NotificationPreference `gorm:"foreignKey:preference_id;references:id" json:"preference,omitempty"`
}

func (*PersonaNotificationPreference) TableName() string {
	return TableNamePersonaNotificationPreference
}
