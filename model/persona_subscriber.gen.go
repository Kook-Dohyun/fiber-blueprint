package model

import (
	"time"
)

const TableNamePersonaSubscriber = "persona_subscriber"

// PersonaSubscriber mapped from table <persona_subscriber>
type PersonaSubscriber struct {
	ID           string     `gorm:"column:id;type:uuid;default:uuid_generate_v4();primaryKey" json:"id"`
	PersonaID    string     `gorm:"column:persona_id;not null" json:"persona_id"`
	SubscriberID string     `gorm:"column:subscriber_id;not null" json:"subscriber_id"`
	IsPaid       *bool      `gorm:"column:is_paid" json:"is_paid,omitempty"`
	Status       string     `gorm:"column:status;not null;default:approved" json:"status"`
	CreatedAt    time.Time  `gorm:"column:created_at;not null;default:CURRENT_TIMESTAMP" json:"created_at"`
	UpdatedAt    *time.Time `gorm:"column:updated_at;not null;autoUpdateTime:milli" json:"updated_at"`
	// 관계 정의
	Persona    *Persona `gorm:"foreignKey:PersonaID;references:ID" json:"persona,omitempty"`
	Subscriber *Persona `gorm:"foreignKey:SubscriberID;references:ID" json:"subscriber,omitempty"`
}

// TableName PersonaSubscriber's table name
func (*PersonaSubscriber) TableName() string {
	return TableNamePersonaSubscriber
}
