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
    "sort"
    "math"
    // "bytes"
    "encoding/json"
)

//Variables

var journalCount = make(map[string]int, 25)

//Structs

type journalRank struct {
  Title string
  Count int
}


type publication struct {
  Title string
  Author string
  Journal string
}

type rankedJournals []journalRank

  func (ranking rankedJournals) Len() int {
    return len(ranking)
  }

  func (ranking rankedJournals) Swap(i, j int) {
    ranking[i], ranking[j] = ranking[j], ranking[i]
  }

  func (ranking rankedJournals) Less(i, j int) bool {
    if ranking[i].Title == "" && ranking[j].Title != "" {return false}
    if ranking[i].Title != "" && ranking[j].Title == "" {return true}
    return ranking[i].Count > ranking[j].Count
  }

type returnData struct {
  JournalCounts map[string]int
}


//Functions

func countJournals (publications []publication) {
  for i := 0 ; i < len(publications); i++ {
    if journalCount[publications[i].Journal] > 0 {
      journalCount[publications[i].Journal]++
      } else {journalCount[publications[i].Journal] = 1}
    }
}

func parseSinglePub ( entryStr string ) ( nextPub publication ) {
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
      publications[i] = parseSinglePub(stringArr[i]);
  }
  resp.Body.Close()
  return publications;
}

func convertAuthorToPPFormat(author string) string {
  author = strings.Join(strings.Split(author, " "), "+")
  author = "%28+%40author+" + author + "%29"
  return author
}

func convertAuthorsToPPFormat(authors []string) string {
  for i := 0; i < len(authors);i++{
    authors[i] = convertAuthorToPPFormat(authors[i])
  }
  return strings.Join(authors, "+%7C+")
}

func findTop (pubCount map[string]int) []journalRank {
  allJournals := make([]journalRank, 501)
  i := 0
  for key, value := range journalCount {
    if len(key) > 2 {
      nextJournal := journalRank{ Title: key, Count: value }
      allJournals[i] = nextJournal
      i++
    }
  }
  sort.Sort(rankedJournals(allJournals))
  topJournals := allJournals[0:100]
  return topJournals
}

func parseAuthors (r *http.Request) ( [][]string ) {
  // fmt.Println(body)
  body,_ := ioutil.ReadAll(r.Body)
  authors := strings.Split(string(body), "|")
  // fmt.Println(authors)
  lengthOrFour := int(math.Min(float64(len(authors)), 4.0))
  firstGroup := authors[0:lengthOrFour]

  groups := make([][]string,1)
  groups[0] = firstGroup
  if len(authors) > 4 {
    secondGroup := authors[4:]
    groups = append(groups, secondGroup)
  }
  return groups
}

func rankingRequestHandler (w http.ResponseWriter, r *http.Request) () {
  journalCount = make(map[string]int, 25)
  groups := parseAuthors(r)

  for i :=0; i < len(groups) ; i++ {
    searchStr := convertAuthorsToPPFormat(groups[i])
    urlPrefix := "http://philpapers.org/asearch.pl?proOnly=on&freeOnly=&newWindow=on&sqc=&publishedOnly=&showCategories=on&langFilter=&searchStr="
    urlSuffix := "&categorizerOn=&filterMode=keywords&onlineOnly=&sort=relevance&filterByAreas=&hideAbstracts=on&format=txt&start=&limit=500&jlist=&ap_c1=&ap_c2="
    fmt.Println(urlPrefix + searchStr + urlSuffix)
    pubList := retrievePubList(urlPrefix + searchStr + urlSuffix)//
    // pubList := retrievePubList("http://www.derekshiller.com/test/test.html")
    countJournals(pubList)
  }
  sortedJournals := findTop(journalCount)
  jsonSortedJournals, _ := json.Marshal(sortedJournals)
  w.Header().Set("Content-Type","application/json")
  w.Write(jsonSortedJournals)
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

  http.Handle("/static/", http.StripPrefix("/static/", http.FileServer(http.Dir("static"))))
  http.HandleFunc("/", viewHandler)
  http.HandleFunc("/json/", rankingRequestHandler)
  http.ListenAndServe(":" + port, nil)
}
