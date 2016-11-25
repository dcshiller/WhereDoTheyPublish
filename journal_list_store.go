package main

type JournalListStore struct {
  Lists map[string]map[string]bool
}

func (jl *JournalListStore) CheckVSList (listName string, journalName string) bool {
    return jl.Lists[listName][journalName]
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