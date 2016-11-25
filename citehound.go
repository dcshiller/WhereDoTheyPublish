package main

import (
    "fmt"
    "io/ioutil"
    "html/template"
    "net/http"
    "os"
    "log"
    "strings"
    "sort"
    "strconv"
    "math"
    "github.com/dcshiller/citehound/titlecap"
    "github.com/dcshiller/citehound/journal_list"
    "github.com/dcshiller/citehound/status_request_handler"
    "github.com/dcshiller/citehound/query"
    "encoding/json"
)

//Variables

var journalCount = make(map[string]int, 25)
var statusMessage string = "This could take some time."
var listStore = journal_list.NewJournalListStore()
var statusRequestHandler = status_request_handler.StatusHandler{StatusMessage: ""}
//Structs

type ajaxRequestMessage struct {
  Authors string `json: "authors"`
  Filter string `json: "filter"`
}

type journalRank struct {
  Title string
  Count int
}

type CR_JSONResponse struct {
  Status string `json:"status"`
  Message message `json:"message"`
}

type message struct {
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
  for _,listItem := range authorList {
    pubAuthorArr := strings.Split(pub.Author, " ")
    listAuthorArr := strings.Split(listItem, " ")
    if pubAuthorArr[0] == listAuthorArr[0] && (len(pubAuthorArr) < 2 ||
      pubAuthorArr[len(pubAuthorArr) - 1] == listAuthorArr[len(listAuthorArr) - 1]) {
      return true
    }
  }
  return false
}

func check(err error) {
  if err != nil {
      statusRequestHandler.SetMessage("There was a problem.")
      panic(err)
   }
}

func convertAuthorToCRFormat(author string) (authorStr string) {
  authorStr = strings.Join(strings.Split(author, " "), "+")
  authorStr = "query.author=" + authorStr
  return authorStr
}

func convertAuthorsToCRFormat(authors []string) string {
  convertedAuthors := make([]string,len(authors))
  for index, author := range authors {
    convertedAuthors[index] = convertAuthorToCRFormat(author)
  }
  return strings.Join(convertedAuthors, "&")
}

func countFilteredJournals (publications []publication, filter string) {
  for _, pub := range publications {
    mainTitle := strings.Split(pub.Journal, ":")[0]
    nextPubJournal := titlecap.Titlize(strings.TrimPrefix(mainTitle, "The "))
    listStore.SetListToCompare("economics")
    recognizedJournal := listStore.CheckVSList(nextPubJournal)
    if filter == "none" { recognizedJournal = true }
    if journalCount[nextPubJournal] > 0 && recognizedJournal {
      journalCount[nextPubJournal]++
    } else if recognizedJournal {journalCount[nextPubJournal] = 1}
      fmt.Println(strconv.Itoa(journalCount[nextPubJournal]))
    }
}

func formatRetrieveAndCount (group []string, filter string) {
  searchStr := convertAuthorsToCRFormat(group)
  urlPrefix := "http://api.crossref.org/works?"
  urlSuffix := "&rows=1000"
  pubList := retrievePubList(urlPrefix + searchStr + urlSuffix, group)//
  countFilteredJournals(pubList, filter)
}

func getLongest ( strArray []string ) string {
  maxLength := 0
  longest := ""
  for _, element := range strArray {
    if len(element) >= maxLength {
      maxLength = len(element)
      longest = element
    }
  }
  return longest
}

func prepList () {
  listStore.LoadJournalNames()
  listStore.SetListToCompare("economics")
}

func parseAuthorsToStringGroups (body string) ( [][]string ) {
  authors := strings.Split(string(body), "|")
  lengthOrFour := int(math.Min(float64(len(authors)), 4.0))
  firstGroup := authors[0:lengthOrFour]
  groups := make([][]string,1)
  groups[0] = firstGroup
  if len(authors) > 4 {
    secondGroup := authors[4:]
    groups = append(groups, secondGroup)
  }
  fmt.Println(firstGroup)
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
    journal = getLongest(itemStruct.Journal)
  } else { journal = "none" }
  nextPub = publication{Title: title , Author: author, Journal: journal }
  return nextPub
}

func rankingRequestHandler (w http.ResponseWriter, r *http.Request) () {
  fmt.Println("Initiating handling of request")
  statusRequestHandler.SetMessage("Initiating handling of request.")
  restartJournalCount()
  query_parser.ParseQuery(r *http.Request)
  body, err := ioutil.ReadAll(r.Body)
  check(err)
  query = query.Query{}.ParseParamsToQuery(r)
  // ajaxRequest := ajaxRequestMessage{}
  // json.Unmarshal(body, &ajaxRequest)
  fmt.Println(ajaxRequest.Filter)
  fmt.Println("Parsing authors into groups")
  statusRequestHandler.SetMessage("Parsing authors into group.")
  groups := parseAuthorsToStringGroups(ajaxRequest.Authors)
  for _, group := range groups {
    fmt.Println("Submitting next Group: " + strings.Join(group, ",") )
    statusRequestHandler.SetMessage("Submitting " + string(strings.Join(group,", ")) +" to CrossRef.")
    formatRetrieveAndCount(group, ajaxRequest.Filter)
  }
  sortedJournals := sortJournalsByQuantity(journalCount)
  jsonSortedJournals, _ := json.Marshal(sortedJournals)
  fmt.Println("Returning list")
  statusRequestHandler.SetMessage("Returning publication list.")
  w.Header().Set("Cope","application/json")
  w.Write(jsonSortedJournals)
}

func restartJournalCount () {
  journalCount = make(map[string]int, 25)
}

func retrievePubList (url string, authorList []string ) []publication {
  response, err := http.Get(url)
  check(err)
  rawData, err := ioutil.ReadAll(response.Body)
  check(err)
  jsonResponse := CR_JSONResponse{}
  json.Unmarshal(rawData, &jsonResponse)
  publications := make([]publication, 1)
  for _, item := range jsonResponse.Message.Items {
    nextPub := parseSinglePub(item)
    if isAuthorAmongQuery(nextPub, authorList) {
      publications = append(publications,nextPub)
    }
  }
  response.Body.Close()
  return publications;
}

func sortJournalsByQuantity (pubCount map[string]int) []journalRank {
  allJournals := make([]journalRank, 1)
  for key, value := range journalCount {
    if len(key) > 2 {
      nextJournal := journalRank{ Title: key, Count: value }
      allJournals = append(allJournals, nextJournal)
    }
  }
  sort.Sort(rankedJournals(allJournals))
  topJournals := allJournals
  return topJournals
}

func mainViewHandler (w http.ResponseWriter, r *http.Request) {
  t, err := template.ParseFiles("index.tmpl.html")
  check(err)
  t.Execute(w, nil)
}

func main () {
  port := os.Getenv("PORT")
  if (port == "") {port = "8080"}

  if port == "" {
    log.Fatal("$PORT must be set")
  }
  
  fmt.Println("Get Ready...")
  
  prepList()
  http.Handle("/static/", http.StripPrefix("/static/", http.FileServer(http.Dir("static"))))
  http.HandleFunc("/", mainViewHandler)
  http.HandleFunc("/wheredotheypublish/", rankingRequestHandler)
  http.HandleFunc("/status/", statusRequestHandler.HandleRequest)
  http.ListenAndServe(":" + port, nil)
}
