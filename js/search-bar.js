var concertsFilter="";
window.addEventListener("load", function () {
  document.getElementById("filter-button").addEventListener("click", switchFilter);
  fillFilter();
  //enabling search after some changes on inputs value 
  document.querySelectorAll("header select ,header input").forEach(input => { input.addEventListener("input", search); });
});
//show-hide filter div.
function switchFilter() {
  var filter = document.getElementById("filter");
  if (filter.style.display == "none" || filter.style.display == "") {
    document.querySelector(".fa-caret-down").className = "fas fa-caret-up";
    filter.style.display = "block";
  } else {
    filter.style.display = "none";
    document.querySelector(".fa-caret-up").className = "fas fa-caret-down";
  }
}

function search() {
  if (isSearching) {
    var artist = document.querySelector("#search-bar>input").value;
    var country = document.getElementById("selected-country").value;
    var city = document.getElementById("selected-city").value;
    var scene = document.getElementById("selected-scene").value;
    var cDate = document.getElementById("c-date").value;
    var fDate = document.getElementById("f-date").value;
    var lDate = document.getElementById("l-date").value;
    //should be improved with if statments
    concertsFilter =`artist=${artist}&country=${country}&city=${city}&scene=${scene}&date=${cDate}&fDate=${fDate}&lDate=${lDate}`;  }
  else {
    concertsFilter="";
  }
  reloadContent();
}
function isSearching() {
  var returned = false;
  document.querySelectorAll("header select ,header input").forEach(input => { if (input.value != "") returned = true; });
  return returned;
}
function fillFilter() {
  var xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function () {
    if (this.readyState == 4 && this.status == 200) {
      var data = JSON.parse(this.responseText);
      data.countries.forEach(country=>{
        document.getElementById("selected-country").innerHTML+=`<option value="${country}">${country}</option>`;
      });
      data.cities.forEach(city=>{
        document.getElementById("selected-city").innerHTML+=`<option value="${city}">${city}</option>`;
      });
      data.scenes.forEach(scene=>{
        document.getElementById("selected-scene").innerHTML+=`<option value="${scene}">${scene}</option>`;
      });
    }
  };
  xhttp.open("POST","php-pages/search.php", true);
  xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
  xhttp.send("filter");
}