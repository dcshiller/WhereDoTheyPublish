package main

import(
  // "io/ioutil"
  "net/http"
  "fmt"
  "os"
)



func handler (w http.ResponseWriter, r *http.Request) {
  fmt.Fprintf(w, "Hello, World!!" )
}

func main () {
  port := os.Getenv("PORT")


	if port == "" {
		log.Fatal("$PORT must be set")
	}

  fmt.Println("HEY BUDDY< THIS IS A TEST< THE PORT NUMBER IS ")
  fmt.Println(port)

  http.HandleFunc("/", handler)
  http.ListenAndServe(port, nil)
  // http.ListenAndServe(":8080", nil)
}
