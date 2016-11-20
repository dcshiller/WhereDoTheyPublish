package journal_list

import (
  "io/ioutil"
  "strings"
)

type JournalListStore struct {
  ListToCompare map[string]bool
  Lists map[string]map[string]bool
}

func NewJournalListStore () JournalListStore {
  emptyComparer := JournalListStore{}
  emptyComparer.ListToCompare = make(map[string]bool)
  emptyComparer.Lists = make(map[string]map[string]bool)
  return emptyComparer
}

func (jl *JournalListStore) CheckVSList ( journalName string ) bool {
    return jl.ListToCompare[journalName]
}

func (jl *JournalListStore) SetListToCompare ( listName string ) {
    jl.ListToCompare = jl.Lists[listName]
}

func (jl *JournalListStore) ReadJournalNames (fileName string, listName string) {
  journalString, _ := ioutil.ReadFile(fileName)
  journalsArr := strings.Split(string(journalString), "\n")
  nextJournal := make(map[string]bool)
  for _,journal := range journalsArr {
    mainTitle := strings.Split(journal, ":")[0]
    mainTitle = strings.TrimPrefix(mainTitle, "The ")
    nextJournal[mainTitle] = true
  }
  jl.Lists[listName] = nextJournal
}

func (jl *JournalListStore) LoadJournalNames () {
  jl.ReadJournalNames("./static/JournalListPhil.txt", "philosophy")
  jl.ReadJournalNames("./static/JournalListEcon.txt", "economics")
  jl.ReadJournalNames("./static/JournalListHist.txt", "history")
  jl.ReadJournalNames("./static/JournalListPsyc.txt", "psychology")
}
