package model

import (
	"time"

	"gorm.io/gorm"
)

const TableNameChatRoomPreference = "chat_room_preference"

// ChatRoomPreference represents participant data for a chat room
type ChatRoomPreference struct {
	ChatRoomID         string    `gorm:"column:chat_room_id;primaryKey;type:text" json:"chat_room_id"`
	PersonaID          string    `gorm:"column:persona_id;primaryKey;type:text" json:"persona_id"`
	JoinedAt           time.Time `gorm:"column:joined_at;not null;autoCreateTime" json:"joined_at"`
	ScreenshotApproved bool      `gorm:"column:screenshot_approved;default:false" json:"screenshot_approved"`
	AlarmEnabled       bool      `gorm:"column:alarm_enabled;default:true" json:"alarm_enabled"`

	// Persona Profile 정보
	PersonaProfile  *PersonaProfile `gorm:"foreignKey:PersonaID;references:PersonaID" json:"-"`
	PersonaName     string          `gorm:"-" json:"persona_name"`
	PersonaImageURL *string         `gorm:"-" json:"persona_image_url,omitempty"`
}

// AfterFind GORM 콜백을 사용하여 Persona 정보 설정
func (c *ChatRoomPreference) AfterFind(tx *gorm.DB) error {
	if c.PersonaProfile != nil {
		c.PersonaName = c.PersonaProfile.DisplayName
		c.PersonaImageURL = c.PersonaProfile.ProfileImageURL
	}
	return nil
}

// TableName ChatRoomPreference's table name
func (*ChatRoomPreference) TableName() string {
	return TableNameChatRoomPreference
}
