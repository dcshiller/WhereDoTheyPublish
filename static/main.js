var searchForm;
var displayPanel;
var boundMove;

function addSample (sampleNum, e) {
  e.preventDefault();
  firstSample = ["Allan Gibbard", "Terry Horgan", "Jack Woods", "Derek Parfit", "Richard Joyce", "Sharon Street", "Mark Schroeder", "Michael Ridge"  ]
  secondSample = ["Peter Carruthers", "Daniel Dennett", "Patricia Churchland", "Susan Schneider", "Jerry Fodor", "David Papineau", "Ruth Millikan", "Murat Aydede" ]
  clear = ["", "", "", "", "", "", "", "" ]

  let fields = document.getElementsByClassName('authorField');
  let sample;
  switch (sampleNum) {
      case 1 :
        sample = firstSample
        break;
      case 2 :
        sample = secondSample
        break;
      default :
        sample = clear
        break;
    }

    for (let i = 0; i <= 8; i++) {
      fields[i].value = sample[i]
    }
}

function assignJournalLis () {
  if (this.readyState == 4) {
  const pubList = document.getElementById("pubList")
  pubList.innerHTML = ""
  let message = JSON.parse(this.responseText)
  for (let i = -1; i < message.length; i++) {
    var newEl = document.createElement("li")
    if (i == -1) {
      newEl.innerHTML = `<strong> Count </strong> <center> Journal Title </center> `
      pubList.appendChild(newEl)
    } else if (message[i].Count > 0) {
      // newEl.innerHTML = `<strong>${message[i].Count}</strong> <span>${message[i].Title}`
      newEl.innerHTML = `<strong>${message[i].Count}</strong> <span>${message[i].Title}</span>`
      pubList.appendChild(newEl)
    }
  }
  document.getElementById("whereTheyPublishButton").disabled = false;
  document.getElementById("whereTheyCiteButton").disabled = false;
}
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

function getRanking (buttonId, url, e) {
  e.preventDefault();
  document.getElementById(buttonId).disabled = true;
  document.getElementById("intro").style.display = 'none';
  let xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = assignJournalLis;
  xhttp.open("POST",url, true)
  let fields = document.getElementsByClassName('authorField')
  params = ""
  for (let i = 0; i < fields.length ; i++) {
    if (fields[i].value != ""){
     params += (fields[i].value) + "|";
  }}
  params = params.slice(0, -1);
  xhttp.send(params);
}

function getWhereTheyPublish (e) {
    getRanking("whereTheyPublishButton", "/wheredotheypublish/", e)
}

function getWhereTheyCite (e) {
    getRanking("whereTheyCiteButton", "/wheredotheycite/", e)
}

function move (coords, DOMelement, e) {
  DOMelement.style.left = coords.DOMOriginX + e.screenX - coords.clickOriginX + "px";
  DOMelement.style.top = coords.DOMOriginY + e.screenY - coords.clickOriginY + "px";
}

function showAbout(e) {
  e.preventDefault();
  document.getElementById("intro").style.display = 'block';
}

function onLoad() {
  var whereTheyPublishButton = document.getElementById("whereTheyPublishButton")
  var whereTheyCiteButton = document.getElementById("whereTheyCiteButton")
  var aboutButton = document.getElementById("aboutButton")
  var body = document.getElementsByTagName("body")[0];
  document.getElementById('sample1').addEventListener("click", addSample.bind(this,1))
  document.getElementById('sample2').addEventListener("click", addSample.bind(this,2))
  document.getElementById('clearButton').addEventListener("click", addSample.bind(this,3))
  searchForm = document.getElementById("searchForm");
  displayPanel = document.getElementById("displayPanel");
  searchForm.addEventListener("mousedown", beginMove.bind(this, searchForm))
  displayPanel.addEventListener("mousedown", beginMove.bind(this, displayPanel))
  document.addEventListener("mouseup", endMove)
  whereTheyPublishButton.addEventListener("click", getWhereTheyPublish)
  whereTheyCiteButton.addEventListener("click", getWhereTheyCite)
  aboutButton.addEventListener("click", showAbout)
}


document.addEventListener("DOMContentLoaded", onLoad, false)
