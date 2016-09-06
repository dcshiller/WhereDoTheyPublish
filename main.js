var searchForm;
var boundMove

function test () {
  console.log("passed");
}

function endMove () {
  searchForm.removeEventListener("mousemove", boundMove)
}

function move (originx, originy, e) {
  searchForm.style.left = e.screenX - originx + "px";
  searchForm.style.top = e.screenY - originy + "px";
}

function beginMove (e) {
  var originx = e.screenX;
  var originy = e.screenY;
  boundMove =  move.bind(this, originx, originy)
   searchForm.addEventListener("mousemove", boundMove)
}

function onLoad() {
  var searchButton = document.getElementById("searchButton")
  searchForm = document.getElementById("searchForm");
  var body = document.getElementsByTagName("body")[0];
  searchForm.addEventListener("mousedown", beginMove)
  body.addEventListener("mouseup", endMove)
}


document.addEventListener("DOMContentLoaded", onLoad, false)
