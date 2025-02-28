package model

import (
	"database/sql/driver"
	"encoding/json"
	"time"

	"github.com/lib/pq"
)

const TableNameMessage = "message"

type MediaType string

const (
	MediaTypeAudio MediaType = "audio"
	MediaTypeImage MediaType = "image"
	MediaTypeVideo MediaType = "video"
	MediaTypeFile  MediaType = "file"
)

// Message represents a chat message
type Message struct {
	ID           string            `gorm:"column:id;primaryKey;type:text;default:uuid_generate_v4()" json:"id"`
	ChatRoomID   string            `gorm:"column:chat_room_id;index;not null" json:"chat_room_id"`
	SenderID     string            `gorm:"column:sender_id;not null" json:"sender_id"`
	ReceiverIDs  pq.StringArray    `gorm:"type:text[];column:receiver_ids" json:"receiver_ids,omitempty"`
	TextContent  *TextContent      `gorm:"type:jsonb;column:text_content" json:"text_content,omitempty"`
	MediaContent MediaContentSlice `gorm:"type:jsonb;column:media_content" json:"media_content,omitempty"`
	CreatedAt    time.Time         `gorm:"column:created_at;not null;autoCreateTime" json:"created_at"`
}

type TextContent struct {
	Text     string                 `json:"text"`
	Mentions []string               `json:"mentions,omitempty"`
	Hashtags []string               `json:"hashtags,omitempty"`
	Metadata map[string]interface{} `json:"metadata,omitempty"`
}

// Value implements the driver.Valuer interface for TextContent
func (tc TextContent) Value() (driver.Value, error) {
	return json.Marshal(tc)
}

// Scan implements the sql.Scanner interface for TextContent
func (tc *TextContent) Scan(value interface{}) error {
	if value == nil {
		return nil
	}
	return json.Unmarshal(value.([]byte), tc)
}

type MediaContent struct {
	URL      string                 `json:"url"`
	Type     MediaType              `json:"type"`
	FileName *string                `json:"file_name,omitempty"`
	FileSize *int64                 `json:"file_size,omitempty"`
	MimeType *string                `json:"mime_type,omitempty"`
	Metadata map[string]interface{} `json:"metadata,omitempty"`

	// Image & Video specific fields
	ThumbnailURL *string `json:"thumbnail_url,omitempty"`
	Width        *int    `json:"width,omitempty"`
	Height       *int    `json:"height,omitempty"`

	// Video & Audio specific fields
	Duration *int    `json:"duration,omitempty"` // in seconds
	Title    *string `json:"title,omitempty"`

	// Audio specific fields
	Artist *string `json:"artist,omitempty"`
}

// MediaContentSlice represents a slice of MediaContent
type MediaContentSlice []MediaContent

// Value implements the driver.Valuer interface for MediaContentSlice
func (mc MediaContentSlice) Value() (driver.Value, error) {
	return json.Marshal(mc)
}

// Scan implements the sql.Scanner interface for MediaContentSlice
func (mc *MediaContentSlice) Scan(value interface{}) error {
	if value == nil {
		return nil
	}
	return json.Unmarshal(value.([]byte), mc)
}

// TableName Message's table name
func (*Message) TableName() string {
	return TableNameMessage
}
