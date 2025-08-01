// Code generated by gorm.io/gen. DO NOT EDIT.
// Code generated by gorm.io/gen. DO NOT EDIT.
// Code generated by gorm.io/gen. DO NOT EDIT.

package model

import (
	"time"

	"github.com/lib/pq"
)

const TableNamePost = "post"

// Post mapped from table <post>
type Post struct {
	ID           string         `gorm:"column:id;primaryKey;type:text;default:uuid_generate_v4()" json:"id"`
	IsAd         bool           `gorm:"column:is_ad;not null" json:"is_ad"`
	AdFeeBalance float64        `gorm:"column:ad_fee_balance" json:"ad_fee_balance"`
	AdIssuerID   string         `gorm:"column:ad_issuer_id" json:"ad_issuer_id"`
	AdAttribute  string         `gorm:"column:ad_attribute;default:undefined" json:"ad_attribute"`
	AdLink       string         `gorm:"column:ad_link" json:"ad_link"`
	AuthorID     string         `gorm:"column:author_id;not null" json:"author_id"`
	OwnerID      string         `gorm:"column:owner_id;not null" json:"owner_id"`
	Content      string         `gorm:"column:content" json:"content"`
	Value        float64        `gorm:"column:value" json:"value"`
	MediaUrls    pq.StringArray `gorm:"type:text[];column:media_urls" json:"media_urls"`
	UpVoteIds    pq.StringArray `gorm:"type:text[];column:up_vote_ids"  json:"up_vote_ids"`
	DownVoteIds  pq.StringArray `gorm:"type:text[];column:down_vote_ids"  json:"down_vote_ids"`
	CreatedAt    time.Time      `gorm:"column:created_at;not null;autoCreateTime" json:"created_at"`
	UpdatedAt    time.Time      `gorm:"column:updated_at" json:"updated_at"`
	Author       *Persona       `gorm:"foreignKey:AuthorID;references:ID" json:"author,omitempty"`
	Owner        *Persona       `gorm:"foreignKey:owner_id;references:id" json:"owner,omitempty"`
	Comments     []Comment      `json:"comments"`
}

// TableName Post's table name
func (*Post) TableName() string {
	return TableNamePost
}
