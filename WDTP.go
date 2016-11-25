package main

import (
    "fmt"
    "html/template"
    // "io/ioutil"
    "net/http"
    "os"
    "log"
    "sort"
    // "strconv"
    "github.com/dcshiller/WhereDoTheyPublish/title_capitalizer"
    // "math"
    // "encoding/json"
)

//Variables

var journalCount = make(map[string]int, 25)
var statusMessage string = "This could take some time."
var statusRequestHandler = StatusHandler{StatusMessage: ""}

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

func check(err error) {
  if err != nil {
      statusRequestHandler.SetMessage("There was a problem.")
      panic(err)
   }
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


// func parseAuthorsToStringGroups (body string) ( [][]string ) {
//   authors := strings.Split(string(body), "|")
//   lengthOrFour := int(math.Min(float64(len(authors)), 4.0))
//   firstGroup := authors[0:lengthOrFour]
//   groups := make([][]string,1)
//   groups[0] = firstGroup
//   if len(authors) > 4 {
//     secondGroup := authors[4:]
//     groups = append(groups, secondGroup)
//   }
//   fmt.Println(firstGroup)
//   return groups
// }

// func parseSinglePub ( itemStruct item ) ( nextPub publication ) {
//   var title string
//   var author string
//   var journal string
//   if len(itemStruct.Title) > 0 {
//     title = itemStruct.Title[0]
//   } else { title = "" }
//   if len(itemStruct.Authors) > 0 {
//     author = itemStruct.Authors[0].Given  + " " + itemStruct.Authors[0].Family
//   } else { author = "" }
//   if len(itemStruct.Journal) > 0 {
//     journal = getLongest(itemStruct.Journal)
//   } else { journal = "none" }
//   nextPub = publication{Title: title , Author: author, Journal: journal }
//   return nextPub
// }

func rankingRequestHandler (w http.ResponseWriter, r *http.Request) () {
  fmt.Println("Initiating handling of request")
  statusRequestHandler.SetMessage("Initiating handling of request.")
  restartJournalCount()
  newQuery := BuildNewQuery(r)
  fmt.Println("Parsing authors into groups")
  statusRequestHandler.SetMessage("Parsing authors into groups.")
  items := Dispatch(newQuery)
  Filter(items, newQuery)
  // fmt.Println("Y: " + string(data[0].Title[0]))
  // // groups := parseAuthorsToStringGroups(newQuery.Authors)
  // for _, group := range groups {
  //   fmt.Println("Submitting next Group: " + strings.Join(group, ",") )
  //   statusRequestHandler.SetMessage("Submitting " + string(strings.Join(group,", ")) +" to CrossRef.")
  //   formatRetrieveAndCount(group, newQuery.Filter)
  // }
  // sortedJournals := sortJournalsByQuantity(journalCount)
  // jsonSortedJournals, _ := json.Marshal(sortedJournals)
  // fmt.Println("Returning list")
  // statusRequestHandler.SetMessage("Returning publication list.")
  // w.Header().Set("Cope","application/json")
  // w.Write(jsonSortedJournals)
}

func restartJournalCount () {
  journalCount = make(map[string]int, 25)
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
  
  http.Handle("/static/", http.StripPrefix("/static/", http.FileServer(http.Dir("static"))))
  http.HandleFunc("/", mainViewHandler)
  http.HandleFunc("/wheredotheypublish/", rankingRequestHandler)
  http.HandleFunc("/status/", statusRequestHandler.HandleRequest)
  http.ListenAndServe(":" + port, nil)
}
