var searchForm, displayPanel, boundMove, pubList, whereTheyPublishButton, body, aboutButton, selectables, fields, intro, elements, filterUl;

function addSample (sampleNum, e) {
  e.preventDefault();
  firstSample = { Philosophy: ["Allan Gibbard", "Terry Horgan", "Jack Woods", "Derek Parfit", "Richard Joyce", "Sharon Street", "Mark Schroeder", "Michael Ridge"  ],
                  Economics: ["Raj Chetty", "Xavier Gabaix", "Emmanuel Saez", "Eammanuel Farhi", "Justin Wolfers", "Nathan Nunn", "Kristin Forbes", "" ],
                  Psychology: ["", "", "", "", "", "", "", "" ],
                  History: ["", "", "", "", "", "", "", "" ],
                  none: ["","","","","","","",""]}
  secondSample = { Philosophy: ["Peter Carruthers", "Daniel Dennett", "Patricia Churchland", "Susan Schneider", "Jerry Fodor", "David Papineau", "Ruth Millikan", "Murat Aydede" ],
                   Economics: ["", "", "", "", "", "", "", "" ],
                   Psychology: ["", "", "", "", "", "", "", "" ],
                   History: ["", "", "", "", "", "", "", "" ],
                   none: ["","","","","","","",""]}
  clear = ["", "", "", "", "", "", "", "" ]

  let filterVal = document.getElementsByClassName('selected')[0].dataset.name
  let sample;
  
  switch (sampleNum) {
      case 1 :
        sample = firstSample[filterVal]
        break;
      case 2 :
        sample = secondSample[filterVal]
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
    exitWaitingState()
    let message = JSON.parse(this.responseText)
    for (let i = -1; i < message.length; i++) {
      var newEl = document.createElement("li")
      if (i == -1) {
        if (message[0].Count == 0) {
          pubList.innerHTML = `<span id="noResults" class="middle"> No results found. </span>`
          break;
        } else {
          newEl.innerHTML = `<strong> Count </strong> <center> Journal Title </center> `
          pubList.appendChild(newEl)
        }
      } else if (message[i].Count > 0 && message[i].Title != "") {
        newEl.innerHTML = `<strong>${message[i].Count}</strong> <span>${message[i].Title}</span>`
        pubList.appendChild(newEl)
      }
    }
    whereTheyPublishButton.disabled = false;
  }
}

function defineVars () {
  searchForm = document.getElementById("searchForm");
  displayPanel = document.getElementById("displayPanel");
  whereTheyPublishButton = document.getElementById("whereTheyPublishButton")
  aboutButton = document.getElementById("aboutButton")
  body = document.getElementsByTagName("body")[0];
  selectables = Array.prototype.slice.call(document.getElementsByClassName("selectable"), 0)
  pubList = document.getElementById("pubList")
  intro = document.getElementById("intro");
  fields = document.getElementsByClassName('authorField')
  filterUl = document.getElementById("filterUl")
}


function enterWaitingState () {
  whereTheyPublishButton.disabled = true;
  intro.style.display = 'none';
  pubList.innerHTML = "<span id='statusUpdate' class='middle'> This could take a while.</span>"
  startTimer();
}

function exitWaitingState () {
  pubList.innerHTML = ""
  removeSpinner();
  clearInterval(window.statusListener)
}

function startTimer () {
  let timer = 0;
  makeSpinner();
  window.statusListener =  setInterval(function(){
    incrementSpinner()
    timer++
    if (timer % 5 == 0) {let xhttp = new XMLHttpRequest();
      xhttp.open("get", "http://wheredotheypublish.derekshiller.com/status/", true)
      xhttp.send();
    xhttp.onreadystatechange = (response) => { document.getElementById("statusUpdate").innerText = this.responseText } 
  }}, 500)
}

function getRanking (url, e) {
  e.preventDefault();
  enterWaitingState();
  let xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = assignJournalLis;
  xhttp.open("POST",url, true)
  // authors = getAuthors.slice(0, -1);
  params = JSON.stringify({authors: getAuthors(), filter: getFilterVal()})
  xhttp.send(params);
}

function getAuthors() {
  let authors = "";
  for (let i = 0; i < fields.length ; i++) {
    if (fields[i].value != ""){
     authors += (fields[i].value) + "|";
  }}
  return authors;
}

function getFilterVal() {
  return document.getElementsByClassName('selected')[0].dataset.name;
}

function getWhereTheyPublish (e) {
    getRanking( "/wheredotheypublish/", e)
}

function hideCategories () {
  let categories = document.querySelectorAll('.category');
  categories.forEach (function(el){el.className = el.className.split("shown").join("");})
}

function incrementSpinner () {
  let activeCircle = document.querySelector('.active');
  circleNum = activeCircle.dataset.circleNum
  let newCircleNum = ((circleNum/1) + 1) % 3
  let nextActiveCircle = document.querySelector(`[data-circle-num~="${newCircleNum}"]`)
  activeCircle.className = "circle"
  nextActiveCircle.className = "circle active"
}

function makeSpinner () {
  let spinnerContainer = document.createElement("span")
  spinnerContainer.id = "spinnerContainer"
  for (let i = 0; i < 3; i++) {
    let spinnerCircle = document.createElement("span")
    spinnerCircle.className = "circle"
    if (i == 0) {
      spinnerCircle.className = "circle active"
    }
    spinnerCircle.dataset.circleNum = i
    spinnerContainer.appendChild(spinnerCircle)
  }
  pubList.appendChild(spinnerContainer)
}

function removeSelectorListener (listener) {
  filterUl.removeEventListener("click", listener);
}

function addSelectorListener (listener) {
  filterUl.addEventListener("click", listener);
}

function removeSpinner () {
  let spinnerContainer = document.getElementById('spinnerContainer')
  if (spinnerContainer) {spinnerContainer.remove()}
}


function selectLi (e) {
  e.preventDefault();
  let thisLi = e.target;
  if (thisLi.className.includes("selected") || thisLi.className.includes("shown")) {e.stopPropagation()}
  hideAllElements(".selectable")
  thisLi.className = thisLi.className + " selected"
  removeSelectorListener(selectLi)
  addSelectorListener(startSearch)
}

function selectSelectable (selectable) {
   selectable.className = selectable.className.split("shown").join("") + " selected"
}

function selectCategory (e) {
  e.preventDefault();
  e.stopPropagation();
  category = e.target.dataset.category
  hideCategories();
  showElements("." + category + ".selectable")
  removeSelectorListener(selectCategory)
  if (e.target.dataset.name == "none") {
    selectSelectable(e.target)
    addSelectorListener(startSearch)
  }
  else {
    let categoryMembers = document.querySelectorAll('.shown');
      if (categoryMembers.length == 1) {
        selectSelectable(categoryMembers[0])
        addSelectorListener(startSearch)
      }
      else {
        addSelectorListener(selectLi)
      }
  }
}

function showAbout(e) {
  e.preventDefault();
  intro.style.display = 'block';
}

function hideElement (element) {
  element.className = element.className.split("shown").join(" ")
  element.className = element.className.split("selected").join(" ")
}

function hideAllElements (selector) {
  let elements = Array.prototype.slice.call(document.querySelectorAll(selector), 0)
  elements.forEach (hideElement)
}

function showElements (selector) {
  let elements = Array.prototype.slice.call(document.querySelectorAll(selector), 0)
  elements.forEach (function(el){el.className += " shown";})
}

function startSearch (e) {
  e.preventDefault();
  hideAllElements('.selected');
  showElements('.category')
  removeSelectorListener(startSearch)
  addSelectorListener(selectCategory)
}

// function writeAuthorName (e){
//   let field = document.getElementById('authorFieldOne');
//   let nameSpan = document.getElementById('authorName');
//   let warning = document.getElementById('warning')
//   if (field.value == ""){
//     nameSpan.innerText = "author 1";
//     warning.innerHTML = ""}
//   else {nameSpan.innerText = field.value;
//    }
// }


function onLoad() {
  defineVars()
  document.getElementById('sample1').addEventListener("click", addSample.bind(this,1))
  document.getElementById('sample2').addEventListener("click", addSample.bind(this,2))
  document.getElementById('clearButton').addEventListener("click", addSample.bind(this,3))
  whereTheyPublishButton.addEventListener("click", getWhereTheyPublish)
  aboutButton.addEventListener("click", showAbout)
  // document.getElementById("authorFieldOne").addEventListener("input", writeAuthorName)
  addSelectorListener(startSearch)
}


document.addEventListener("DOMContentLoaded", onLoad, false)
