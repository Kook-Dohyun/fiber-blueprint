package routes

import (
	"fiber_server/config"
	"fiber_server/model"
	"strconv"

	"github.com/gofiber/fiber/v3"
)

func SetupHomeFeedRoutes(app *fiber.App) {
	feedGroup := app.Group("/home_feed")
	feedGroup.Get("/", getRecommendedPosts)
}

func getRecommendedPosts(c fiber.Ctx) error {
	// 쿼리 파라미터
	limitStr := c.Query("limit", "10")  // 기본값 "10"
	offsetStr := c.Query("offset", "0") // 기본값 "0"
	// 문자열을 정수로 변환
	limit, err := strconv.Atoi(limitStr)
	if err != nil {
		limit = 10 // 변환 실패시 기본값
	}

	offset, err := strconv.Atoi(offsetStr)
	if err != nil {
		offset = 0 // 변환 실패시 기본값
	}
	var posts []model.Post

	/* 	// 추천 게시물 쿼리
	   	// 1. up_vote_ids 배열 길이로 인기도 측정
	   	// 2. 최신 게시물 우선
	   	// 3. 광고 게시물 포함
	   	query := config.DB.Model(&model.Post{}).
	   		Select("*, array_length(up_vote_ids, 1) as up_votes_count").
	   		Preload("Author").
	   		Preload("Author.Profile").
	   		Preload("Comments").
	   		Order("array_length(up_vote_ids, 1) DESC, created_at DESC").
	   		Limit(limit).
	   		Offset(offset)

	   		// 인기도를 고려한 랜덤
	   	query := config.DB.Model(&model.Post{}).
	   		Select("*, array_length(up_vote_ids, 1) as up_votes_count").
	   		Preload("Author").
	   		Preload("Author.Profile").
	   		Preload("Comments").
	   		Order("array_length(up_vote_ids, 1) * RANDOM() DESC"). // 좋아요 수와 랜덤 값을 곱하여 정렬
	   		Limit(limit).
	   		Offset(offset) */

	query := config.DB.Model(&model.Post{}).
		// Preload("Author").
		Preload("Author.Profile").
		Preload("Owner.Profile").
		Preload("Comments").
		Order("RANDOM()"). // 랜덤 정렬
		Limit(limit).
		Offset(offset)

	if err := query.Find(&posts).Error; err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "게시물을 불러오는데 실패했습니다",
		})
	}

	return c.JSON(fiber.Map{
		"message": "추천 피드 조회 성공",
		"data": fiber.Map{
			"posts": posts,
			"pagination": fiber.Map{
				"limit":  limit,
				"offset": offset,
			},
		},
	})
}
