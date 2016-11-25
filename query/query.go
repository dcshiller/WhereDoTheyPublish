package query


type Query struct {
  Authors string `json: "authors"`
  Filter string `json: "filter"`
}

func (ql *Query) MarshalParamsToQuery (r *http.Request){
  body, _ := ioutil.ReadAll(r.Body)
  json.Unmarshal(body, &ql)  
}