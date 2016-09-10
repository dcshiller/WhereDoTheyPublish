package main

import (
    // "fmt"
    "io/ioutil"
    "html/template"
    "net/http"
    "os"
    "log"
    "bytes"
    "encoding/json"
)

// Your API key is YUwLUPslNpcO9nkK and your user ID is 7192.


func viewHandler(w http.ResponseWriter, r *http.Request) {
  t, _ := template.ParseFiles("index.tmpl.html")
  t.Execute(w, nil)
}

func processWebData (url string) [][]byte {
  resp, _ := http.Get(url)
  byteStr, _ := ioutil.ReadAll(resp.Body)
  bytesArr := bytes.Split(byteStr, []byte{'\n'})
  resp.Body.Close()
  return bytesArr
}

type publication struct {
  Title string
  Author string
  Journal string
}

func jsonHandler (w http.ResponseWriter, r *http.Request) () {
  Data := publication{Title: "Hidden Qualia", Author: "Derek Shiller", Journal: "Review of Philosophy and Psychology"}
  jData, _ := json.Marshal(Data)
  // fmt.Println(jData)
  w.Header().Set("Content-Type","application/json")
  // json.NewEncoder(w).Encode(Data)
  w.Write(jData)
}

func main() {
  // bytesArr := processWebData("http://www.derekshiller.com")
  // fmt.Println("HTML:\n\n", string(bytesArr[3]))

  port := os.Getenv("PORT")
  if (port == "") {port = "8080"}

  if port == "" {
    log.Fatal("$PORT must be set")
  }

  http.Handle("/static/", http.StripPrefix("/static/", http.FileServer(http.Dir("static"))))
  http.HandleFunc("/", viewHandler)
  http.HandleFunc("/json/",jsonHandler)
  http.ListenAndServe(":" + port, nil)
}
