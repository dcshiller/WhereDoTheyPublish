package main

import (
  "io/ioutil"
  "strings"
  "sort"
  "fmt"
  "os"
  "github.com/dcshiller/citehound/titlecap"
)

type alphabetic []string
  func (stringArr alphabetic) Len() int {
    return len(stringArr)
  }

  func (stringArr alphabetic) Swap(i,j int) {
    stringArr[i], stringArr[j] = stringArr[j], stringArr[i]
  }

  func (stringArr alphabetic) Less(i, j int) bool {
    return stringArr[i] < stringArr[j]
  }


func processJournalNames (location string) {
  journalString, _ := ioutil.ReadFile(location)
  output := string(journalString)
  ioutil.WriteFile("..citehound/static/backup.txt", []byte(output), 0644)
  journalsArr := strings.Split(string(journalString), "\n")
  newArr := make([]string, 0)
  dictionary := make(map[string]bool, 100)
  dictionary[""] = true
  for i := 0; i < len(journalsArr); i++ {
    // if !(len(journalsArr[i]) < 6 ||
    //       journalsArr[i][0:4] == "ISSN" ||
    //       journalsArr[i][0:6] == "EconLi" ||
    //       journalsArr[i][0:4] == "Back" ||
    //       journalsArr[i][0:4] == "See:" ||
    //       journalsArr[i][0:6] == "Former") {
    nextJournal := strings.TrimPrefix(journalsArr[i], "The ")
    nextJournal = strings.Split(nextJournal, "[")[0]
    fmt.Println(nextJournal)
    nextJournal = titlecap.Titlize(nextJournal)
    nextJournal = strings.Trim(nextJournal, " ")
    if !(dictionary[nextJournal]) {
      newArr = append(newArr, nextJournal)
    }
      dictionary[nextJournal] = true
    // }
  }
  sort.Sort(alphabetic(newArr))
  output = strings.Join(newArr, "\n")
  ioutil.WriteFile(location, []byte(output), 0644)
}

func main () {
  fmt.Println("Starting...")
  allArgs := os.Args
  processJournalNames("../static/" + allArgs[1])
}
