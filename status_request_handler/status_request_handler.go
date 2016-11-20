package status_request_handler

import (
  "net/http"
)

type StatusHandler struct {
  StatusMessage string
}

func (sh StatusHandler) SetMessage (newMessage string) {
  sh.StatusMessage = newMessage
}

func (sh StatusHandler) GetMessage () string {
  return sh.StatusMessage
}

func (sh StatusHandler) HandleRequest (w http.ResponseWriter, r* http.Request) () {
  jsonifiedStatus := []byte(sh.GetMessage())
  w.Header().Set("Cope","application/json")
  w.Write(jsonifiedStatus)
}