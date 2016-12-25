var searchForm, displayPanel, boundMove, pubList, whereTheyPublishButton, body, aboutButton, selectables, fields, intro, elements, filterUl;


function assignJournalLis (arg) {
    enterWaitingState()
    exitWaitingState()
    let message = JSON.parse(arg)
    for (let i = -1; i < message.length; i++) {
      var newEl = document.createElement("tr")
      if (i == -1) {
        if (message[0].Count == 0) {
          pubList.innerHTML = `<span id="noResults" class="middle"> No results found. </span>`
          break;
        } else {
          newEl.innerHTML = `<th> <strong> Count </strong> </th> <th> Journal Title </th> `
          pubList.appendChild(newEl)
        }
      } else if (message[i].Count > 0 && message[i].Title != "") {
        newEl.innerHTML = `<td> <strong>${message[i].Count}</strong> </td> <td>${message[i].Title}</td>`
        pubList.appendChild(newEl)
      }
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


function getRanking (url, e) {
  // e.preventDefault();
  // enterWaitingState();
  // let xhttp = new XMLHttpRequest();
  // xhttp.onreadystatechange = assignJournalLis;
  // xhttp.open("POST", url, true)
  // // authors = getAuthors.slice(0, -1);
  // params = JSON.stringify({authors: getAuthors(), filter: getFilterVal()})
  // xhttp.send("params");
}

function getAuthors() {
  let authors = [];
  for (let i = 0; i < fields.length ; i++) {
    if (fields[i].value != ""){
     authors.push(fields[i].value);
  }}
  console.log(authors.join(", "))
  return authors;
}

function getFilterVal() {
  return document.getElementsByClassName('selected')[0].dataset.name;
}

function getWhereTheyPublish (e) {
  getRanking( "/query/", e)
}

function hideCategories () {
  let categories = document.querySelectorAll('.category');
  categories.forEach (function(el){el.className = el.className.split("shown").join("");})
}

function removeSelectorListener (listener) {
  filterUl.removeEventListener("click", listener);
}

function addSelectorListener (listener) {
  filterUl.addEventListener("click", listener);
}

function selectLi (e) {
  e.preventDefault();
  let thisLi = e.target;
  if (thisLi.className.includes("selected") || thisLi.className.includes("shown")) {e.stopPropagation()}
  hideAllElements(".selectable")
  thisLi.className = thisLi.className + " selected"
  document.getElementById('filter').value = thisLi.dataset.name
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
  // whereTheyPublishButton.addEventListener("click", getWhereTheyPublish)
  aboutButton.addEventListener("click", showAbout)
  // document.getElementById("authorFieldOne").addEventListener("input", writeAuthorName)
  addSelectorListener(startSearch)
}

function requestNumber() {
  return document.getElementById("requestNumber").value
}

document.addEventListener("DOMContentLoaded", onLoad, false)
