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

  router := gin.New()
	router.Use(gin.Logger())
	router.LoadHTMLGlob("index.tmpl.html")
	// router.Static("/assets", "./assets")
	// router.Static("/assets/master.css", "./assets/master.css")
	router.StaticFile("/xvxcvxmaster.css","./master.css")
	router.StaticFile("/xcvcxvxmain.js","./main.js")

	router.GET("/", func(c *gin.Context) {
		c.HTML(http.StatusOK, "index.tmpl.html", nil)
	})

	router.Run(":" + port)
}
