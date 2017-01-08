// // # <% self.class.include Rails.application.routes.url_helpers %>
// var status_path = "status_path" // <%= "'#{status_path}'" %> 
 
function enterWaitingState () {
  // whereTheyPublishButton.disabled = true;
  intro.style.display = 'none';
  pubList.innerHTML = "<span id='statusUpdate' class='middle'> This could take a while.</span>";
  startTimer();
}

function exitWaitingState () {
  pubList.innerHTML = "";
  removeSpinner();
  clearInterval(window.statusListener);
}

function startTimer () {
  var timer = 0;
  makeSpinner();
  window.statusListener =  setInterval(function(){
    incrementSpinner();
    timer++;
    if (timer % 3 == 0) {var xhttp = new XMLHttpRequest();
      xhttp.open("get", status_path + '?request_number=${requestNumber()}', true);
      xhttp.send();
    xhttp.onreadystatechange = function(response){ if (xhttp.readyState == 4){ document.getElementById("statusUpdate").innerText = xhttp.responseText } } 
  }}, 300);
}

function incrementSpinner () {
  var activeCircle = document.querySelector('.active');
  var circleNum = activeCircle.dataset.circleNum;
  var newCircleNum = ((circleNum/1) + 1) % 3;
  var nextActiveCircle = document.querySelector('[data-circle-num~="${newCircleNum}"]');
  activeCircle.className = "circle";
  nextActiveCircle.className = "circle active";
}

function makeSpinner () {
  var spinnerContainer = document.createElement("span");
  spinnerContainer.id = "spinnerContainer";
  for (var i = 0; i < 3; i++) {
    var spinnerCircle = document.createElement("span");
    spinnerCircle.className = "circle";
    if (i == 0) {
      spinnerCircle.className = "circle active";
    }
    spinnerCircle.dataset.circleNum = i
    spinnerContainer.appendChild(spinnerCircle);
  }
  pubList.appendChild(spinnerContainer);
}

function removeSpinner () {
  var spinnerContainer = document.getElementById('spinnerContainer');
  if (spinnerContainer) {spinnerContainer.remove();}
}