package main

import(
  // "github.com/dcshiller/WhereDoTheyPublish/query_builder"
  "net/http"
  "io/ioutil"
  "encoding/json"
  "strings"
)

type jsonResponse struct {
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

func Dispatch (q Query) (dataset []item) {
  dataset = make([]item, 1)
  groups := groupifyAuthors(q)
  for _, group := range groups {
    responseData := parseResponse( dispatchGroup(group) )
    dataset = append(dataset, responseData...)
  }  
  return dataset
}

func groupifyAuthors (q Query) ( [][]string ) {
  groups := make([][]string, 1)
  return append(groups, q.Authors)
}

func dispatchGroup (group []string) (response *http.Response) {
  searchStr := convertAuthorsToCRFormat(group)
  urlPrefix := "http://api.crossref.org/works?"
  urlSuffix := "&rows=1000"
  response, _ = http.Get(urlPrefix + searchStr + urlSuffix)//
  // func formatRetrieveAndCount (group []string, filter string) {
  // countFilteredJournals(pubList, filter)
  return response
}  
  
func parseResponse (response *http.Response) (dataset []item) {
  rawData, _ := ioutil.ReadAll(response.Body)
  jsonData := jsonResponse{}
  json.Unmarshal(rawData, &jsonData)
  response.Body.Close()
  return jsonData.Message.Items
}

func convertAuthorToCRFormat (author string) (authorStr string) {
  authorStr = strings.Join(strings.Split(author, " "), "+")
  authorStr = "query.author=" + authorStr
  return authorStr
}

func convertAuthorsToCRFormat (authors []string) string {
  convertedAuthors := make([]string,len(authors))
  for index, author := range authors {
    convertedAuthors[index] = convertAuthorToCRFormat(author)
  }
  return strings.Join(convertedAuthors, "&")
}
