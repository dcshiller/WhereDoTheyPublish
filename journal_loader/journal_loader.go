package journal_loader

import (
  "io/ioutil"
  "strings"
)

var econJournalNames = make(map[string]bool, 1915)
var histJournalNames = make(map[string]bool, 386)
var philJournalNames = make(map[string]bool, 290)
var psychJournalNames = make(map[string]bool, 112)

var listToCompare = make(map[string]bool)

func CheckVSList ( journalName string ) bool {
    return listToCompare[journalName]
}

func SetListToCompare ( listName string ) {
    listsMap := map[string]map[string]bool{
      "economics": econJournalNames,
      "history": histJournalNames,
      "philosophy": philJournalNames,
      "psychology": psychJournalNames }
    list := listsMap[listName]
    listToCompare = list
}

func readJournalNamesIntoSet (fileName string, journalSet map[string]bool) {
  journalString, _ := ioutil.ReadFile(fileName)
  journalsArr := strings.Split(string(journalString), "\n")
  for _,journal := range journalsArr {
    mainTitle := strings.Split(journal, ":")[0]
    mainTitle = strings.TrimPrefix(mainTitle, "The ")
    journalSet[mainTitle] = true
  }
}

func LoadJournalNames () {
  readJournalNamesIntoSet("./static/JournalListPhil.txt", philJournalNames)
  readJournalNamesIntoSet("./static/JournalListEcon.txt", econJournalNames)
  readJournalNamesIntoSet("./static/JournalListHist.txt", histJournalNames)
  readJournalNamesIntoSet("./static/JournalListPsyc.txt", psychJournalNames)
}
