package main

import (
  "io/ioutil"
  "net/http"
  "encoding/json"
  "fmt"
)

type Query struct {
  Authors []string `json: "authors"`
  Filter string `json: "filter"`
}

func BuildNewQuery (r *http.Request) Query {
  newQuery := Query{}
  newQuery.UnmarshalParamsToQuery(r)
  fmt.Println(newQuery.Authors)
  return newQuery
}

func (ql *Query) UnmarshalParamsToQuery (r *http.Request){
  body, _ := ioutil.ReadAll(r.Body)
  fmt.Println(string(body))
  json.Unmarshal(body, &ql)  
}