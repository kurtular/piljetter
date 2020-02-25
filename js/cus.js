window.addEventListener("DOMContentLoaded", function () {
  reloadContent();
  setInterval(reloadContent, 10000);
});
function reloadContent() {
  ajax("php-pages/cus.php", "showUserNb","");
  if(isSearching()==false){ajax("php-pages/search.php", "show_concerts","");}
}
function ajax(link, methodToCall,post) {
  var xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function () {
    if (this.readyState == 4 && this.status == 200) {
      var data = JSON.parse(this.responseText);
      // TO check which action will be done.
      switch (methodToCall) {
        case "showUserNb": showUserNb(data.user); break;
        case "show_concerts": show_concerts(data.concerts); break;
        default: ;
      }
    }
  };
  xhttp.open("POST", link, true);
  xhttp.send(post);
}
function show_concerts(data) {
  var content = document.getElementById("content");
  if (content != null) {
    var newContent = "";
    data.forEach(ele => {
      newContent += `<div class="concert">` +
        `<div class="artist">${ele.artistName}.</div>` +
        `<div class="building">${ele.sceneName}.</div>` +
        `<div class="address">${ele.address}<div class="city-country">${ele.city}</div></div>` +
        `<div class="date">${ele.date} ${ele.time}</div>` +
        `<div class="price">${ele.ticketPrice}</div>` +
        `<div class="amount">${ele.remainingTickets} biljetter kvar.</div>` +
        `<i onclick="buy(${ele.concertId})" class="fas fa-cart-plus addToCart"></i>` +
        `</div>`;
    });
    if (newContent != content.innerHTML) {
      content.innerHTML = newContent;
    }
  }
}
function showUserNb(data) {
  var userName = document.querySelector("#user-name");
  var userBalance = document.querySelector("#user-balance");
  if (data.name != userName.innerHTML && userBalance.innerHTML != data.balance) {
    userName.innerHTML = data.name;
    userBalance.innerHTML = data.balance;
  }
}

//todo
function buy(itemId) {
  if (itemId != null && window.confirm('Är du säker om att köpa en biljett?')) {
    window.alert("yes");
  }
}