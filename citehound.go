package main

import (
    "fmt"
    "regexp"
    "io/ioutil"
    "html/template"
    "net/http"
    "os"
    "log"
    "strings"
    // "bytes"
    "encoding/json"
)

// Your API key is YUwLUPslNpcO9nkK and your user ID is 7192.

type publication struct {
  Title string
  Author string
  Journal string
}

type returnData struct {
  JournalCounts map[string]int
}

func countJournals (publications []publication) map[string]int {
  var pubCount = make(map[string]int, 25)
  for i := 0 ; i < len(publications); i++ {
    if pubCount[publications[i].Journal] > 0 {
      pubCount[publications[i].Journal]++
      } else {pubCount[publications[i].Journal] = 1}
    }
    fmt.Println(pubCount["mind"])
    return pubCount;
}

func parsePub ( entryStr string ) ( nextPub publication ) {
  titleReg := regexp.MustCompile("[)].*[[:space:]][_]")
  journalReg := regexp.MustCompile("[[:space:]][_].*[_][[:space:]]")
  title := titleReg.FindAllString(entryStr, -1)
  journal := journalReg.FindAllString(entryStr, -1)
  if len(title) == 0 {title = []string{""}}
  if len(journal) == 0 {journal = []string{""}}
  titleStr := strings.Trim(title[0], ")._ ")
  journalStr := strings.Trim(journal[0], ")._ ")
  nextPub = publication{Title: titleStr, Author: "tbd", Journal: journalStr}
  return nextPub
}

func retrievePubList (url string) []publication {
  resp, _ := http.Get(url)
  rawData, _ := ioutil.ReadAll(resp.Body)
  entryReg := regexp.MustCompile(".*-.")
  stringArr := entryReg.FindAllString(string(rawData), -1)
  publications := make([]publication, 501)
  for i := 0 ; i < len(stringArr); i++ {
      publications[i] = parsePub(stringArr[i]);
  }
  resp.Body.Close()
  return publications;
}

func rankingRequestHandler (w http.ResponseWriter, r *http.Request) () {
  rawData := retrievePubList("http://www.derekshiller.com/test/test.html")//publication{Title: "Hidden Qualia", Author: "Derek Shiller", Journal: "Review of Philosophy and Psychology"}
  talliedData := returnData{JournalCounts: countJournals(rawData)}
  jData, _ := json.Marshal(talliedData)
  w.Header().Set("Content-Type","application/json")
  w.Write(jData)
}

func topTenJournals (pubCount map[string]int) {

}

func viewHandler (w http.ResponseWriter, r *http.Request) {
  t, _ := template.ParseFiles("index.tmpl.html")
  t.Execute(w, nil)
}

func main() {
  port := os.Getenv("PORT")
  if (port == "") {port = "8080"}

  if port == "" {
    log.Fatal("$PORT must be set")
  }
  // retrievePubList("http://www.derekshiller.com/test/test.html")

  http.Handle("/static/", http.StripPrefix("/static/", http.FileServer(http.Dir("static"))))
  http.HandleFunc("/", viewHandler)
  http.HandleFunc("/json/", rankingRequestHandler)
  http.ListenAndServe(":" + port, nil)
}
