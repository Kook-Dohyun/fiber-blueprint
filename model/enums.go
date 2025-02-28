package model

// MembershipType - 회원 유형 ENUM
type MembershipType string

const (
	MembershipTypeFree    MembershipType = "free"
	MembershipTypePremium MembershipType = "premium"
)

// PersonaType - 개인/조직 ENUM
type PersonaType string

const (
	PersonaTypePersonal     PersonaType = "personal"
	PersonaTypeOrganization PersonaType = "organization"
)

// BusinessType - 비즈니스 타입 ENUM
type BusinessType string

const (
	BusinessTypeCorporation BusinessType = "corporation"
	BusinessTypeIndividual  BusinessType = "individual"
	BusinessTypeFreelancer  BusinessType = "freelancer"
	BusinessTypeNonProfit   BusinessType = "non_profit"
)

// MemberRole - 멤버 역할 ENUM
type MemberRole string

const (
	MemberRoleAdmin   MemberRole = "admin"
	MemberRoleManager MemberRole = "manager"
	MemberRoleMember  MemberRole = "member"
)

// VerifiedStatus - 인증 상태 ENUM
type VerifiedStatus string

const (
	VerifiedStatusPending  VerifiedStatus = "pending"
	VerifiedStatusApproved VerifiedStatus = "approved"
	VerifiedStatusRejected VerifiedStatus = "rejected"
	VerifiedStatusExpired  VerifiedStatus = "expired"
)

// RegistrationSource - 가입 경로 ENUM
type RegistrationSource string

const (
	RegistrationSourceMobileApp  RegistrationSource = "mobile_app"
	RegistrationSourceWebBrowser RegistrationSource = "web_browser"
	RegistrationSourcePartnerApp RegistrationSource = "partner_app"
)

// AdAttribute - 광고 속성 ENUM
type AdAttribute string

const (
	AdAttributeArt       AdAttribute = "art"
	AdAttributeProduct   AdAttribute = "product"
	AdAttributeService   AdAttribute = "service"
	AdAttributeUndefined AdAttribute = "undefined"
)

type SubscriptionStatus string

const (
	SubscriptionStatusPending   SubscriptionStatus = "pending"
	SubscriptionStatusApproved  SubscriptionStatus = "approved"
	SubscriptionStatusRejected  SubscriptionStatus = "rejected"
	SubscriptionStatusCancelled SubscriptionStatus = "cancelled"
	SubscriptionStatusExpired   SubscriptionStatus = "expired"
)
