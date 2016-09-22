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

type CR_JSONResponse struct {
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

func isAuthorAmongQuery (pub publication, authorList []string) bool {
  fmt.Println(pub.Author)
  for _,listItem := range authorList {
    fmt.Println(listItem)
    if pub.Author == listItem {
      return true
    }
  }
  return false
}

func check(err error) {
  if err != nil {
       panic(err)
   }
}

func convertAuthorToCRFormat(author string) (authorStr string) {
  authorStr = strings.Join(strings.Split(author, " "), "+")
  authorStr = "query.author=" + authorStr
  return authorStr
}

func convertAuthorsToCRFormat(authors []string) string {
  convertedAuthors := make([]string,1)
  for i := 0; i < len(authors);i++{
    convertedAuthors[i] = convertAuthorToCRFormat(authors[i])
  }
  return strings.Join(convertedAuthors, "&")
}

func countFilteredJournals (publications []publication) {
  for i := 0 ; i < len(publications); i++ {
    nextPubJournal := publications[i].Journal;
    // recognizedJournal := journalNames[nextPubJournal]
    // if journalCount[nextPubJournal] > 0 && recognizedJournal {
      journalCount[nextPubJournal]++
      // } else if recognizedJournal {journalCount[nextPubJournal] = 1}
    }
}

func sortJournalsByQuantity (pubCount map[string]int) []journalRank {
  allJournals := make([]journalRank, 501)
  for key, value := range journalCount {
    if len(key) > 2 {
      nextJournal := journalRank{ Title: key, Count: value }
      allJournals[i] = nextJournal
    }
  }
  sort.Sort(rankedJournals(allJournals))
  topJournals := allJournals[0:100]
  return topJournals
}

func parseAuthorsToStringGroups (r *http.Request) ( [][]string ) {
  body, err := ioutil.ReadAll(r.Body)
  check(err)
  authors := strings.Split(string(body), "|")
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
  return nextPub
}

func rankingRequestHandler (w http.ResponseWriter, r *http.Request) () {
  restartJournalCount()
  groups := parseAuthorsToStringGroups(r)
  for group := range groups {
    formatRetrieveAndCount(group)
  }
  sortedJournals := sortJournalsByQuantity(journalCount)
  jsonSortedJournals, _ := json.Marshal(sortedJournals)
  w.Header().Set("Cope","application/json")
  w.Write(jsonSortedJournals)
}

func readJournalNamesIntoArray () {
  journalString, err := ioutil.ReadFile("./static/JournalList.txt")
  check(err)
  journalsArr := strings.Split(string(journalString), "\n")
  for i := 0; i < len(journalsArr); i++ {
    journalNames[journalsArr[i]] = true
  }
}

func restartJournalCount () {
  journalCount = make(map[string]int, 25)
}

func formatRetrieveAndCount (group []string) {
  searchStr := convertAuthorsToCRFormat(group)
  urlPrefix := "http://api.crossref.org/works?"
  urlSuffix := "&rows=1000"
  pubList := retrievePubList(urlPrefix + searchStr + urlSuffix, groups[i])//
  countFilteredJournals(pubList)
}

func retrievePubList (url string, authorList []string ) []publication {
  response, err := http.Get(url)
  check(err)
  rawData, err := ioutil.ReadAll(response.Body)
  check(err)
  jsonResponse := CR_JSONResponse{}
  json.Unmarshal(rawData, &jsonResponse)
  publications := make([]publication, 1000)
  for i, item := range jsonResponse.Query.Items {
    nextPub := parseSinglePub(item)
    if isAuthorAmongQuery(nextPub, authorList) {
      publications[i] = nextPub
      // fmt.Println(nextPub.Title)
      // fmt.Println(nextPub.Author)
      // fmt.Println(nextPub.Journal)
    }
  }
  response.Body.Close()
  return publications;
}

func mainViewHandler (w http.ResponseWriter, r *http.Request) {
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

  readJournalNamesIntoArray()
  // printJournal2014Counts()
  http.Handle("/static/", http.StripPrefix("/static/", http.FileServer(http.Dir("static"))))
  http.HandleFunc("/", mainViewHandler)
  http.HandleFunc("/wheredotheypublish/", rankingRequestHandler)
  http.ListenAndServe(":" + port, nil)
}
