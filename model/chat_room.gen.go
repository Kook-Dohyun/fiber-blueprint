package model

import (
	"time"
)

const TableNameChatRoom = "chat_room"

// ChatRoom represents a chat room between two personas
type ChatRoom struct {
	ID            string               `gorm:"column:id;primaryKey;type:text;default:uuid_generate_v4()" json:"id"`
	CreatedAt     time.Time            `gorm:"column:created_at;not null;autoCreateTime" json:"created_at"`
	UpdatedAt     time.Time            `gorm:"column:updated_at;not null;autoUpdateTime:milli" json:"updated_at"`
	CreateBy      string               `gorm:"column:create_by;not null" json:"create_by,omitempty"` // 채팅방 생성자 Persona ID
	LastMessageID *string              `gorm:"column:last_message_id" json:"last_message_id,omitempty"`
	LastMessage   *Message             `gorm:"foreignKey:id;references:last_message_id" json:"last_message,omitempty"`
	Messages      []Message            `gorm:"foreignKey:chat_room_id;references:id" json:"messages,omitempty"`
	Participants  []ChatRoomPreference `gorm:"foreignKey:chat_room_id;references:id" json:"participants,omitempty"`
}

// TableName ChatRoom's table name
func (*ChatRoom) TableName() string {
	return TableNameChatRoom
}
