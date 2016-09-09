package main

import (
    // "fmt"
    // "io/ioutil"
    "html/template"
    "net/http"
)

func viewHandler(w http.ResponseWriter, r *http.Request) {
  t, _ := template.ParseFiles("index.tmpl.html")
  t.Execute(w, nil)
}

func main() {
  fs := http.FileServer(http.Dir("Static"))
  http.Handle("/",fs)
  http.Handle("/static/", http.StripPrefix("/static/", http.FileServer(http.Dir("static"))))
  http.HandleFunc("/", viewHandler)
  http.ListenAndServe(":8080", nil)
}
