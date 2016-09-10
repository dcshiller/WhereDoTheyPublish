var searchForm;
var displayPanel;
var boundMove

function test () {
  console.log("passed");
}

function beginMove (DOMelement, e) {
  var coords = {}
  coords.clickOriginX = e.screenX;
  coords.clickOriginY = e.screenY;
  var rect = DOMelement.getBoundingClientRect();
  coords.DOMOriginX = rect.left;
  coords.DOMOriginY = rect.top;
  boundMove =  move.bind(this, coords, DOMelement)
  document.addEventListener("mousemove", boundMove)
}

function endMove () {
  document.removeEventListener("mousemove", boundMove)
}

function move (coords, DOMelement, e) {
  DOMelement.style.left = coords.DOMOriginX + e.screenX - coords.clickOriginX + "px";
  DOMelement.style.top = coords.DOMOriginY + e.screenY - coords.clickOriginY + "px";
}

function queryRequest (e) {
  e.preventDefault();
  let xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function () {
    if (this.readyState == 4) {
    let message = JSON.parse(this.responseText)
    debugger
    for (let i = 0; i < 25; i++) {
      var newEl = document.createElement("li")
      newEl.innerText = message[i].Journal
      document.getElementById("pubList").appendChild(newEl)
    }
 }
  }
  // let url = window.location.hostname == "localhost" ? "http://localhost:8080/json/" :
  xhttp.open("GET","/json/", true)
  xhttp.send();
}

function onLoad() {
  var searchButton = document.getElementById("searchButton")
  searchForm = document.getElementById("searchForm");
  displayPanel = document.getElementById("displayPanel");
  var body = document.getElementsByTagName("body")[0];
  searchForm.addEventListener("mousedown", beginMove.bind(this, searchForm))
  displayPanel.addEventListener("mousedown", beginMove.bind(this, displayPanel))
  document.addEventListener("mouseup", endMove)
  searchButton.addEventListener("click", queryRequest)
}


document.addEventListener("DOMContentLoaded", onLoad, false)
