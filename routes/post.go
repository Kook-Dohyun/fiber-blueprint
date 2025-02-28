package routes

import (
	"encoding/json"
	"errors"
	"fiber_server/config"
	"fiber_server/model"
	"fiber_server/routes/middleware/authority"
	"fmt"
	"log"

	"github.com/gofiber/fiber/v3"
	"github.com/lib/pq"
	"gorm.io/gorm"
)

func SetupPostRoutes(app *fiber.App) {
	postGroup := app.Group("/post")
	postGroup.Get("/:id", getPost)
	postGroup.Put("/:id", updatePost)
	postGroup.Delete("/:id", deletePost)
}

func getPost(c fiber.Ctx) error {
	id := c.Params("id")
	if id == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "required post id",
		})
	}

	var post model.Post
	if err := config.DB.Model(&model.Post{}).
		Preload("Author").
		Preload("Author.Profile").
		Preload("Owner").
		Preload("Owner.Profile").
		Preload("Comments").
		Preload("Comments.Author").
		Preload("Comments.Author.Profile").
		Where("id = ?", id).
		First(&post).Error; err != nil {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error": "could not find post",
		})
	}

	return c.JSON(fiber.Map{
		"message": "retrieve post successfully",
		"data":    post,
	})
}

// updatePost : 게시물 수정
func updatePost(c fiber.Ctx) error {
	// POST ID 검증
	id := c.Params("id")
	if id == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "post id is required",
		})
	}

	// 요청 데이터 파싱
	var input struct {
		Content   string   `json:"content,omitempty"`
		MediaUrls []string `json:"media_urls,omitempty"`
	}
	if err := json.Unmarshal(c.Body(), &input); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "invalid request body",
		})
	}

	// 최소 하나의 필드는 있어야 함
	if input.Content == "" && len(input.MediaUrls) == 0 {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "at least one field (content or media_urls) is required",
		})
	}

	var post model.Post

	// 트랜잭션 시작
	err := config.DB.Transaction(func(tx *gorm.DB) error {
		// 1. 게시물 조회
		if err := tx.Preload("Owner").First(&post, "id = ?", id).Error; err != nil {
			if errors.Is(err, gorm.ErrRecordNotFound) {
				return err
			}
			log.Printf("❌ Failed to fetch post: %v", err)
			return fmt.Errorf("failed to fetch post")
		}

		// 2. DID로 소유자 검증
		if err := authority.ValidateOwnerByDid(c, tx, post.OwnerID); err != nil {
			return err
		}

		// 3. 업데이트할 필드만 포함하여 맵 생성
		updates := make(map[string]interface{})
		if input.Content != "" {
			updates["content"] = input.Content
		}
		if len(input.MediaUrls) > 0 {
			updates["media_urls"] = pq.StringArray(input.MediaUrls)
		}

		// 4. 게시물 업데이트
		if err := tx.Model(&post).Updates(updates).Error; err != nil {
			log.Printf("❌ Failed to update post: %v", err)
			return fmt.Errorf("failed to update post")
		}

		// 5. 업데이트된 게시물 재조회
		if err := tx.Preload("Owner").
			Preload("Owner.Profile").
			First(&post, "id = ?", id).Error; err != nil {
			log.Printf("❌ Failed to fetch updated post: %v", err)
			return fmt.Errorf("failed to fetch updated post")
		}

		log.Printf("✅ Post updated successfully - ID: %s", id)
		return nil
	})

	// 에러 처리
	if err != nil {
		switch {
		case errors.Is(err, gorm.ErrRecordNotFound):
			return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
				"error": "post not found",
			})
		case err.Error() == "unauthorized":
			return c.Status(fiber.StatusForbidden).JSON(fiber.Map{
				"error": "unauthorized to update this post",
			})
		default:
			log.Printf("❌ Internal error: %v", err)
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"error": "failed to process request",
			})
		}
	}

	// 성공 응답
	return c.JSON(fiber.Map{
		"message": "post updated successfully",
		"data":    post,
	})
}

// deletePost : 게시물 삭제
func deletePost(c fiber.Ctx) error {
	// POST ID 검증
	id := c.Params("id")
	if id == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "post id is required",
		})
	}

	var post model.Post

	// 트랜잭션 시작
	err := config.DB.Transaction(func(tx *gorm.DB) error {
		// 1. 게시물 조회
		if err := tx.Preload("Owner").First(&post, "id = ?", id).Error; err != nil {
			if errors.Is(err, gorm.ErrRecordNotFound) {
				return err
			}
			log.Printf("❌ Failed to fetch post: %v", err)
			return fmt.Errorf("failed to fetch post")
		}

		// 2. DID로 소유자 검증
		if err := authority.ValidateOwnerByDid(c, tx, post.OwnerID); err != nil {
			return err
		}

		// 3. 게시물 삭제 (cascade)
		if err := tx.Delete(&post).Error; err != nil {
			log.Printf("❌ Failed to delete post: %v", err)
			return fmt.Errorf("failed to delete post")
		}

		log.Printf("✅ Post deleted successfully - ID: %s", id)
		return nil
	})

	// 에러 처리
	if err != nil {
		switch {
		case errors.Is(err, gorm.ErrRecordNotFound):
			return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
				"error": "post not found",
			})
		case err.Error() == "unauthorized":
			return c.Status(fiber.StatusForbidden).JSON(fiber.Map{
				"error": "unauthorized to delete this post",
			})
		default:
			log.Printf("❌ Internal error: %v", err)
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"error": "failed to process request",
			})
		}
	}

	// 성공 응답
	return c.JSON(fiber.Map{
		"message": "post deleted successfully",
		"data": fiber.Map{
			"id":       post.ID,
			"owner_id": post.OwnerID,
		},
	})
}


