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

    for (let i = 0; i < 8; i++) {
      fields[i].value = sample[i]
    }
}

function assignJournalLis () {
  if (this.readyState == 4) {
  const pubList = document.getElementById("pubList")
  pubList.innerHTML = ""
  let message = JSON.parse(this.responseText)
  for (let i = -1; i < message.length; i++) {
    if (i == -1) {
      if (message[1].Count == 0) {
        pubList.innerHTML = `<span id="noResults" class="middle"> No results found. </span>`
      } else {
        newEl.innerHTML = `<strong> Count </strong> <center> Journal Title </center> `
      }
    } else if (message[i].Count > 0 && message[i].Title != "") {
      var newEl = document.createElement("li")
      newEl.innerHTML = `<strong>${message[i].Count}</strong> <span>${message[i].Title}</span>`
      pubList.appendChild(newEl)
    }
  }
  document.getElementById("whereTheyPublishButton").disabled = false;
  // document.getElementById("whereTheyCiteButton").disabled = false;
}
}

function enterWaitingState () {
  document.getElementById("whereTheyPublishButton").disabled = true;
  document.getElementById("intro").style.display = 'none';
  let pubList = document.getElementById("pubList")
  pubList.innerHTML = "<span class='middle'> This could take a while</span>"

}

function getRanking (url, e) {

  e.preventDefault();
  enterWaitingState();
  let xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = assignJournalLis;
  xhttp.open("POST",url, true)
  let fields = document.getElementsByClassName('authorField')
  let authors = ""
  for (let i = 0; i < fields.length ; i++) {
    if (fields[i].value != ""){
     authors += (fields[i].value) + "|";
  }}
  authors = authors.slice(0, -1);
  filterVal = document.getElementsByClassName('selected')[0].innerText
  console.log(filterVal)
  params = JSON.stringify({authors: authors, filter: filterVal})
  xhttp.send(params);
}

function getWhereTheyPublish (e) {
    getRanking( "/wheredotheypublish/", e)
}

function showAbout(e) {
  e.preventDefault();
  document.getElementById("intro").style.display = 'block';
}

function writeAuthorName (e){
  let field = document.getElementById('authorFieldOne');
  let nameSpan = document.getElementById('authorName');
  let warning = document.getElementById('warning')
  if (field.value == ""){
    nameSpan.innerText = "author 1";
    warning.innerHTML = ""}
  else {nameSpan.innerText = field.value;
   }
}

function selectLi (e) {
  e.preventDefault();
  let thisLi = e.target;
  if (thisLi.className.includes("shown")) {e.stopPropagation()}
  let selectables = Array.prototype.slice.call(document.getElementsByClassName("selectable"), 0)
  selectables.forEach (function(el){el.className = "selectable";})
  thisLi.className = thisLi.className + " selected"
  setTimeout(function(){document.getElementById("filterUl").addEventListener("click", showSelectables)}, 1000)
}

function showSelectables (e) {
  e.preventDefault();
  let selectables = Array.prototype.slice.call(document.getElementsByClassName("selectable"), 0)
  selectables.forEach (function(el){el.className += " shown";})
  document.getElementById("filterUl").removeEventListener("click", showSelectables)
}

function onLoad() {
  var whereTheyPublishButton = document.getElementById("whereTheyPublishButton")
  // var whereTheyCiteButton = document.getElementById("whereTheyCiteButton")
  var aboutButton = document.getElementById("aboutButton")
  var body = document.getElementsByTagName("body")[0];
  document.getElementById('sample1').addEventListener("click", addSample.bind(this,1))
  document.getElementById('sample2').addEventListener("click", addSample.bind(this,2))
  document.getElementById('clearButton').addEventListener("click", addSample.bind(this,3))
  searchForm = document.getElementById("searchForm");
  displayPanel = document.getElementById("displayPanel");
  // searchForm.addEventListener("mousedown", beginMove.bind(this, searchForm))
  // displayPanel.addEventListener("mousedown", beginMove.bind(this, displayPanel))
  // document.addEventListener("mouseup", endMove)
  whereTheyPublishButton.addEventListener("click", getWhereTheyPublish)
  // whereTheyCiteButton.addEventListener("click", getWhereTheyCite)
  // whereTheyCiteButton.addEventListener("mouseover", showWarning)
  // whereTheyCiteButton.addEventListener("mouseleave", hideWarning)
  aboutButton.addEventListener("click", showAbout)
  document.getElementById("authorFieldOne").addEventListener("input", writeAuthorName)
  let selectables = Array.prototype.slice.call(document.getElementsByClassName("selectable"), 0)
  selectables.forEach(function(el){el.addEventListener("click", selectLi)})
  document.getElementById("filterUl").addEventListener("click", showSelectables)
  // document.getElementById("filterUl").addEventListener("mouseleave", hideSelectables)
}


document.addEventListener("DOMContentLoaded", onLoad, false)
