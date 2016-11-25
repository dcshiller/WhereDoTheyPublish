package main

import (
  // "github.com/dcshiller/WhereDoTheyPublish/journal_list_loader"
)

var listStore = Load()

func Filter (data []item, query Query, journalListToCheck string) []item {
  returnData := make([]item, 1)
  for _,datum := range data {
    if (isInAuthorList(query, datum) && isInJournalList(journalListToCheck, datum)) {
      returnData = append(returnData, datum)
    }
  }
  return returnData
}

func isInAuthorList(query Query, datum item) bool { 
    authorList := query.Authors
    author = datum.Author
    for _, listEntry := range authorList {
      if author == listEntry {return true}
    }
    return false
}

func isInJournalList(journalListToCheck string, datum item) bool {
    journalName = datum.Journal
    for _, listEntry := range listStore[journalListToCheck] {
      if journalName == listEntry {return true} 
    }
    return false
}

// func isAuthorAmongQuery (pub publication, authorList []string) bool {
//   for _,listItem := range authorList {
//     pubAuthorArr := strings.Split(pub.Author, " ")
//     listAuthorArr := strings.Split(listItem, " ")
//     if pubAuthorArr[0] == listAuthorArr[0] && (len(pubAuthorArr) < 2 ||
//       pubAuthorArr[len(pubAuthorArr) - 1] == listAuthorArr[len(listAuthorArr) - 1]) {
//       return true
//     }
//   }
//   return false
// }
