package main

import(
  // "io/ioutil"
  "net/http"
  "fmt"
)

func handler (w http.ResponseWriter, r *http.Request) {
  fmt.Fprintf(w, "Hello, World!!" )
}

func main () {
  http.HandleFunc("/", handler)
  http.ListenAndServe(":8080", nil)
}
