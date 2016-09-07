package main

import (
	"log"
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
)

func main() {
	// port := os.Getenv("PORT")

	if port == "" {
		log.Fatal("SREEED")
		log.Fatal("$PORT must be set")
	}

	router := gin.New()
	router.Use(gin.Logger())
	router.LoadHTMLGlob("templates/*.tmpl.html")
	router.Static("/static", "static")
	router.Static("/javascript", "javascript")

	router.GET("/ping", func(c *gin.Context) {

		})

	router.GET("/", func(c *gin.Context) {
		fmt.Println("SREEED")
		c.String(200, "pong")
		// c.HTML(http.StatusOK, "index.tmpl.html", nil)
	})

	router.Run(":" + port)
}
