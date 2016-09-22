package main

import (
    "fmt"
    // "regexp"
    "io/ioutil"
    "html/template"
    "net/http"
    "os"
    "log"
    "strings"
    "sort"
    // "strconv"
    "math"
    // "math/rand"
    // "time"
    // "bytes"
    "encoding/json"
)

//Variables

var journalCount = make(map[string]int, 25)
var journalNames = make(map[string]bool, 172)

//Structs

type journalRank struct {
  Title string
  Count int
}

type message struct {
  Status string `json:"status"`
  Query query `json:"message"`
}

type query struct {
  Items []item `json:items`
}

type item struct {
  Title []string `json:"title"`
  Authors []author `json:"author"`
  Journal []string `json:"container-title"`
}

type author struct {
  Family string `json:"family"`
  Given string `json:"given"`
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

func check(err error) {
  if err != nil {
       panic(err)
   }
}

func convertAuthorToCRFormat(author string) string {
  author = strings.Join(strings.Split(author, " "), "+")
  author = "query.author=" + author
  return author
}

func convertAuthorsToCRFormat(authors []string) string {
  for i := 0; i < len(authors);i++{
    authors[i] = convertAuthorToCRFormat(authors[i])
  }
  return strings.Join(authors, "&")
}

func countJournals (publications []publication) {
  for i := 0 ; i < len(publications); i++ {
    nextPubJournal := publications[i].Journal;
    recognizedJournal := journalNames[nextPubJournal]
    if journalCount[nextPubJournal] > 0 && recognizedJournal {
      journalCount[nextPubJournal]++
      } else if recognizedJournal {journalCount[nextPubJournal] = 1}
    }
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
  body, err := ioutil.ReadAll(r.Body)
  check(err)
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

func parseSinglePub ( itemStruct item ) ( nextPub publication ) {
  var title string
  var author string
  var journal string
  if len(itemStruct.Title) > 0 {
    title = itemStruct.Title[0]
  } else { title = "" }
  if len(itemStruct.Authors) > 0 {
    author = itemStruct.Authors[0].Given  + " " + itemStruct.Authors[0].Family
  } else { author = "" }
  if len(itemStruct.Journal) > 0 {
    journal = itemStruct.Journal[0]
  } else { journal = "none" }
  nextPub = publication{Title: title , Author: author, Journal: journal }
  // titleReg := regexp.MustCompile("[)].*[[:space:]][_]")
  // journalReg := regexp.MustCompile("[[:space:]][_].*[_][[:space:]]")
  // title := titleReg.FindAllString(entryStr, -1)
  // journal := journalReg.FindAllString(entryStr, -1)
  // if len(title) == 0 {title = []string{""}}
  // if len(journal) == 0 {journal = []string{""}}
  // titleStr := strings.Trim(title[0], ")._ ")
  // journalStr := strings.Trim(journal[0], ")._ ")
  // nextPub = publication{Title: titleStr, Author: "tbd", Journal: journalStr}
  return nextPub
}

func rankingByPubsRequestHandler (w http.ResponseWriter, r *http.Request) () {
  journalCount = make(map[string]int, 25)
  groups := parseAuthors(r)
  for i :=0; i < len(groups) ; i++ {
    searchStr := convertAuthorsToCRFormat(groups[i])
    urlPrefix := "http://api.crossref.org/works?"
    urlSuffix := "&rows=1000"
    fmt.Println(urlPrefix + searchStr + urlSuffix)
    pubList := retrievePubList(urlPrefix + searchStr + urlSuffix)//
    countJournals(pubList)
  }
  sortedJournals := findTop(journalCount)
  jsonSortedJournals, _ := json.Marshal(sortedJournals)
  w.Header().Set("Content-Type","application/json")
  w.Write(jsonSortedJournals)
}

func readJournalNames () {
  journalString, err := ioutil.ReadFile("./static/JournalList.txt")
  check(err)
  journalsArr := strings.Split(string(journalString), "\n")
  for i := 0; i < len(journalsArr); i++ {
    journalNames[journalsArr[i]] = true
  }
}

func retrievePubList (url string) []publication {
  resp, err := http.Get(url)
  check(err)
  rawData, err := ioutil.ReadAll(resp.Body)
  check(err)
  messageStruct := message{}
  json.Unmarshal(rawData, &messageStruct)
  publications := make([]publication, 1000)
  for i, item := range messageStruct.Query.Items {
    nextPub := parseSinglePub(item)
    publications[i] = nextPub
    if nextPub.Author == "Derek Shiller" {
      fmt.Println("found one")
    }
    fmt.Println(nextPub.Title)
    fmt.Println(nextPub.Author)
    fmt.Println(nextPub.Journal)
  }
  resp.Body.Close()
  return publications;
}

func viewHandler (w http.ResponseWriter, r *http.Request) {
  t, err := template.ParseFiles("index.tmpl.html")
  check(err)
  t.Execute(w, nil)
}

func main() {
  port := os.Getenv("PORT")
  if (port == "") {port = "8080"}

  if port == "" {
    log.Fatal("$PORT must be set")
  }

  readJournalNames()
  // printJournal2014Counts()
  http.Handle("/static/", http.StripPrefix("/static/", http.FileServer(http.Dir("static"))))
  http.HandleFunc("/", viewHandler)
  http.HandleFunc("/wheredotheypublish/", rankingByPubsRequestHandler)
  // http.HandleFunc("/wheredotheycite/", rankingByCitesRequestHandler)
  http.ListenAndServe(":" + port, nil)
}
