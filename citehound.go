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
var econJournalNames = make(map[string]bool, 1915)
var histJournalNames = make(map[string]bool, 386)
var philJournalNames = make(map[string]bool, 290)

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
  convertedAuthors := make([]string,len(authors))
  for index, author := range authors {
    convertedAuthors[index] = convertAuthorToCRFormat(author)
  }
  return strings.Join(convertedAuthors, "&")
}

func countFilteredJournals (publications []publication, filter string) {
  journalListToCheck := make(map[string]bool, 120)
  if filter == "Economics" {
    journalListToCheck = econJournalNames
  } else if filter == "History" {
    journalListToCheck = histJournalNames
  } else if filter == "Philosophy" {
    journalListToCheck = philJournalNames
  }
  for _, pub := range publications {
    nextPubJournal := strings.TrimPrefix(pub.Journal, "The ")
    recognizedJournal := journalListToCheck[nextPubJournal]
    if journalCount[nextPubJournal] > 0 && recognizedJournal {
      journalCount[nextPubJournal]++
      } else if recognizedJournal {journalCount[nextPubJournal] = 1}
    }
}

func formatRetrieveAndCount (group []string, filter string) {
  searchStr := convertAuthorsToCRFormat(group)
  urlPrefix := "http://api.crossref.org/works?"
  urlSuffix := "&rows=1000"
  pubList := retrievePubList(urlPrefix + searchStr + urlSuffix, group)//
  countFilteredJournals(pubList, filter)
}

func getLongest ( strArray []string) string {
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

func parseAuthorsToStringGroups (body string) ( [][]string ) {
  // body, err := ioutil.ReadAll(r.Body)
  // check(err)
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
  restartJournalCount()
  body, err := ioutil.ReadAll(r.Body)
  check(err)
  ajaxRequest := ajaxRequestMessage{}
  json.Unmarshal(body, &ajaxRequest)
  fmt.Println(ajaxRequest.Filter)
  groups := parseAuthorsToStringGroups(ajaxRequest.Authors)
  for _, group := range groups {
    formatRetrieveAndCount(group, ajaxRequest.Filter)
  }
  sortedJournals := sortJournalsByQuantity(journalCount)
  jsonSortedJournals, _ := json.Marshal(sortedJournals)
  w.Header().Set("Cope","application/json")
  w.Write(jsonSortedJournals)
}

func readJournalNamesIntoSet (fileName string, journalSet map[string]bool) {
  journalString, err := ioutil.ReadFile(fileName)
  check(err)
  journalsArr := strings.Split(string(journalString), "\n")
  for i := 0; i < len(journalsArr); i++ {
    journalSet[journalsArr[i]] = true
  }
}
//
// func removeExcessJournalNames () {
//   journalString, err := ioutil.ReadFile("./static/JournalList2.txt")
//   check(err)
//   journalsArr := strings.Split(string(journalString), "\n")
//   newArr := make([]string, 5000)
//   for i := 0; i < len(journalsArr); i++ {
//     if !(len(journalsArr[i]) < 6 ||
//           journalsArr[i][0:4] == "ISSN" ||
//           journalsArr[i][0:6] == "EconLi" ||
//           journalsArr[i][0:4] == "Back" ||
//           journalsArr[i][0:4] == "See:" ||
//           journalsArr[i][0:6] == "Former") {
//       newArr = append(newArr, journalsArr[i])
//     }
//   }
//   x := strings.Join(newArr, "\n")
//   ioutil.WriteFile("./static/JournalList22.txt", []byte(x), 0644)
//   check(err)
// }

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
  publications := make([]publication, 1000)
  for i, item := range jsonResponse.Message.Items {
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

func sortJournalsByQuantity (pubCount map[string]int) []journalRank {
  allJournals := make([]journalRank, 501)
  i := 0
  for key, value := range journalCount {
    if len(key) > 2 {
      nextJournal := journalRank{ Title: key, Count: value }
      allJournals[i] = nextJournal
    }
    i++
  }
  sort.Sort(rankedJournals(allJournals))
  topJournals := allJournals[0:100]
  return topJournals
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
  fmt.Println("Get Ready...")

  readJournalNamesIntoSet("./static/JournalListPhil.txt", philJournalNames);
  readJournalNamesIntoSet("./static/JournalListEcon.txt", econJournalNames);
  readJournalNamesIntoSet("./static/JournalListHist.txt", histJournalNames);
  // removeExcessJournalNames()
  // printJournal2014Counts()
  http.Handle("/static/", http.StripPrefix("/static/", http.FileServer(http.Dir("static"))))
  http.HandleFunc("/", mainViewHandler)
  http.HandleFunc("/wheredotheypublish/", rankingRequestHandler)
  http.ListenAndServe(":" + port, nil)
}
