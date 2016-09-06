package main

import(
  // "io/ioutil"
  "net/http"
  "fmt"
  "log"
  "github.com/gin-gonic/gin"
  "os"
)

func main () {
  port := os.Getenv("PORT")
  if (port == "") {port = "8080"}

	if port == "" {
		log.Fatal("$PORT must be set")
	}

  fmt.Println("HEY BUDDY< THIS IS A TEST< THE PORT NUMBER IS ")
  fmt.Println(port)

  router := gin.New()
	router.Use(gin.Logger())
	router.LoadHTMLGlob("index.tmpl.html")
	router.Static("/static", "static")

	router.GET("/", func(c *gin.Context) {
		c.HTML(http.StatusOK, "index.tmpl.html", nil)
	})

	router.Run(":" + port)
}
