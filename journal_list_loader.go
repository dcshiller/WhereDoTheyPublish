package main

import (
  "io/ioutil"
  "strings"
)

func Load () JournalListStore {
  emptyComparer := JournalListStore{}
  emptyComparer.Lists = make(map[string]map[string]bool)
  return emptyComparer
}
