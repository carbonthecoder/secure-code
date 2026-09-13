package main

import (
	"crypto/subtle"
	"log"
	"os"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/helmet"
	"github.com/gofiber/fiber/v2/middleware/limiter"
)

type CreateOrderRequest struct {
	ItemSKU      string `json:"item_sku" validate:"required,alphanum,max=32"`
	Quantity     int    `json:"quantity" validate:"required,min=1,max=100"`
	PriceInCents int64  `json:"price_in_cents" validate:"required,min=0"`
}

func main() {
	app := fiber.New(fiber.Config{
		ReadTimeout:  5 * time.Second,
		WriteTimeout: 10 * time.Second,
		IdleTimeout:  120 * time.Second,
	})

	// 🛡️ 1. Security Headers (Helmet)
	app.Use(helmet.New())

	// 🛡️ 2. Rate Limiting (Brute-force / DDoS Protection)
	app.Use(limiter.New(limiter.Config{
		Max:        100,
		Expiration: 1 * time.Minute,
	}))

	expectedToken := []byte(os.Getenv("SECRET_API_TOKEN"))

	// 🛡️ 3. Timing-Safe Auth Guard
	app.Use(func(c *fiber.Ctx) error {
		clientToken := []byte(c.Get("X-API-Token"))
		if subtle.ConstantTimeCompare(clientToken, expectedToken) != 1 {
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
				"error": "Unauthorized access",
			})
		}
		return c.Next()
	})

	app.Post("/orders", func(c *fiber.Ctx) error {
		var req CreateOrderRequest
		if err := c.BodyParser(&req); err != nil {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
				"error": "Invalid payload format",
			})
		}

		return c.Status(fiber.StatusCreated).JSON(fiber.Map{
			"status": "confirmed",
			"order":  req,
		})
	})

	log.Fatal(app.Listen(":8080"))
}
