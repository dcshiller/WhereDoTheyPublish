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
    "strconv"
    "math"
    // "math/rand"
    "time"
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

// func chooseCode(codeArr []string) string {
//   var code string = "undefined"
//   for string(code) == "undefined" {
//     randomNumber := rand.Intn(len(codeArr))
//     code = codeArr[randomNumber]
//     codeArr[randomNumber] = "undefined"
//   }
//
//   return code
// }

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

func printJournal2014Counts () {
  for jName := range journalNames {
    codedJName := strings.Join(strings.Split(jName," "),"+")
    prefix := "http://philpapers.org/search/advanced.pl?filterMode=advanced&newWindow=on&sort=relevance&appendMSets=on&minYear=2014&showCategories=on&maxYear=2014&hideAbstracts=on&advMode=fields&publication="
    suffix := "&proOnly=on&limit=500&sqc=&format=txt&start=&jlist=&publishedOnly=&filterByAreas=&freeOnly=&langFilter=&ap_c1=&ap_c2="
    fmt.Println(prefix + codedJName + suffix)
    url := prefix + codedJName + suffix
    resp, err := http.Get(url)
      check(err)
      rawData, err := ioutil.ReadAll(resp.Body)
      check(err)
      splitJName := strings.Join(strings.Split(jName, ""), "][")
      splitJName = "[" + splitJName + "]"
      entryReg := regexp.MustCompile("[_].*" + splitJName + "[_]")
      stringArr := entryReg.FindAllString(string(rawData), -1)
      fmt.Println(jName + " " + strconv.Itoa(len(stringArr)))
      resp.Body.Close()
    time.Sleep(time.Second * 5)
  }
}

func rankingByPubsRequestHandler (w http.ResponseWriter, r *http.Request) () {
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
//
// func rankingByCitesRequestHandler (w http.ResponseWriter, r *http.Request) {
//   journalCount = make(map[string]int, 25)
//   author := parseAuthors(r)[0][0]
//   fmt.Println(author)
//   searchStr := strings.Join(strings.Split(author, " "), "%20")
//   urlPrefix := "http://philpapers.org/s/@author%20"
//   urlSuffix := "%20@pubType%20journal"
//   fmt.Println(urlPrefix + searchStr + urlSuffix)
//   // testUrl := "http://www.derekshiller.com/test/test2.html"
//   pubCodes := retrievePubCode(urlPrefix + searchStr + urlSuffix)
//   fmt.Println(pubCodes)
//   for i := 0; i < int(math.Min(10.0,float64(len(pubCodes)))); i++ {
//     //prefix :=  "http://philpapers.org/asearch.pl?hideAbstracts=on&sort=firstAuthor&publishedOnly=&categorizerOn=&sqc=&showCategories=on&freeOnly=&newWindow=on&start=1&direction=references&onlineOnly=&proOnly=on&langFilter=&eId="
//     prefix :=  "http://philpapers.org/asearch.pl?hideAbstracts=on&sort=firstAuthor&publishedOnly=&categorizerOn=&sqc=&showCategories=on&freeOnly=&newWindow=on&start=1&direction=references&onlineOnly=&proOnly=on&langFilter=&eId="
//     // suffix := "&noFilter=1&filterByAreas=&format=txt&limit=500&jlist=&ap_c1=&ap_c2="
//     suffix := "&noFilter=1&filterByAreas=&format=txt&limit=500&jlist=&ap_c1=&ap_c2="
//     nextCode := chooseCode(pubCodes)
//     fmt.Println(prefix + nextCode + suffix)
//     pubList := retrievePubList(prefix + nextCode + suffix)
//     // pubList := retrievePubList("http://www.derekshiller.com/test/test.html")
//     countJournals(pubList)
//     time.Sleep(time.Second * 3)
//   }
//   sortedJournals := findTop(journalCount)
//   fmt.Println(sortedJournals[0].Title)
//   jsonSortedJournals, _ := json.Marshal(sortedJournals)
//   w.Header().Set("Content-Type","application/json")
//   w.Write(jsonSortedJournals)
// }

func readJournalNames () {
  journalString, err := ioutil.ReadFile("./static/JournalList.txt")
  check(err)
  journalsArr := strings.Split(string(journalString), "\n")
  for i := 0; i < len(journalsArr); i++ {
    journalNames[journalsArr[i]] = true
  }
}
//
// func retrievePubCode (url string) (codeArr []string) {
//   resp, err := http.Get(url)
//   check(err)
//   rawData, err := ioutil.ReadAll(resp.Body)
//   check(err)
//   //li id='e..' onclick
//   // fmt.Println(string(rawData))
//   // codeReg := regexp.MustCompile("/citations/(.{5,7})\"")  // .*['].[o][n][c]")
//   codeReg := regexp.MustCompile("/rec/(.{5,10})'")  // .*['].[o][n][c]")
//   // codeReg := regexp.MustCompile("[l][i].[i][d][=]['][e].*$") // .*['].[o][n][c]")
//   codeArr = codeReg.FindAllString(string(rawData), -1)
//   for i := 0; i < len(codeArr); i++ {
//     codeArr[i] = strings.Split(codeArr[i],"/rec/")[1]
//     codeArr[i] = strings.Trim(codeArr[i], "'")
//   }
//   // fmt.Println(strings.Join(codeArr, "\n"))
//   return codeArr
// }

func retrievePubList (url string) []publication {
  resp, err := http.Get(url)
  check(err)
  rawData, err := ioutil.ReadAll(resp.Body)
  check(err)
  entryReg := regexp.MustCompile(".*-.")
  stringArr := entryReg.FindAllString(string(rawData), -1)
  publications := make([]publication, 501)
  for i := 0 ; i < len(stringArr); i++ {
      publications[i] = parseSinglePub(stringArr[i]);
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
  printJournal2014Counts()
  http.Handle("/static/", http.StripPrefix("/static/", http.FileServer(http.Dir("static"))))
  http.HandleFunc("/", viewHandler)
  http.HandleFunc("/wheredotheypublish/", rankingByPubsRequestHandler)
  // http.HandleFunc("/wheredotheycite/", rankingByCitesRequestHandler)
  http.ListenAndServe(":" + port, nil)
}
