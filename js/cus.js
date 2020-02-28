window.addEventListener("load", function () {
  buyPesetas();
  reloadContent();
  setInterval(reloadContent, 10000);
});

function reloadContent() {
  if (document.getElementById("search-bar") != null) {
    ajax("php-pages/search.php", "showConcerts",concertsFilter);
  }
  ajax("php-pages/cus.php", "showUserNb", "");
  ajax("php-pages/cus.php", "showTickets", "");
  ajax("php-pages/cus.php", "showVouchers", "");
}
function ajax(link, methodToCall,post) {
  var xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function () {
    if (this.readyState == 4 && this.status == 200) {
      var data = JSON.parse(this.responseText);
      // TO check which action will be done.
      switch (methodToCall) {
        case "showUserNb": showUserNb(data.user); break;
        case "showConcerts": showConcerts(data.concerts); break;
        case "showTickets": showTickets(data.tickets); break;
        case "showVouchers": showVouchers(data.vouchers); break;
        case "showResponse": alert(data.msg); break;
        default:;
      }
    }
  };
  xhttp.open("POST", link, true);
  xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
  xhttp.send(post);
}
function showConcerts(data) {
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
  if (data.name != userName.innerHTML || userBalance.innerHTML != data.balance) {
    userName.innerHTML = data.name;
    userBalance.innerHTML = data.balance;
  }
}
function buy(itemId) {
  if (itemId != null && window.confirm('Är du säker om att köpa en biljett?')) {
    if(window.confirm("Skulle du använda en kupong för det?")){
      var voucherId;
      voucherId=window.prompt("Inmata gärna din kupong id");
      if(voucherId !=null){console.log(voucherId);ajax("php-pages/cus.php", "showResponse",`itemId=${itemId}&vouchId=${voucherId}`);}
    }else{
      ajax("php-pages/cus.php", "showResponse",`itemId=${itemId}`);
    }
    reloadContent();
  }
}


function showTickets(data) {
  var content = document.getElementById("tickets");
  if (content != null) {
    content.innerHTML = "";
    data.forEach(ele => {
      if (ele.vouchered == true) {
        (ele.ticketPrice = "Kupong")
      }
      content.innerHTML += `<div class="profiletables">` +
        `<div class=cell id="hashtag">${ele.ticketId}</div>` +
        `<div class=cell id="artist">${ele.artistName}</div>` +
        `<div class=cell id="building">${ele.sceneName}</div>` +
        `<div class=cell id="address">${ele.city}</div>` +
        `<div class=cell id="country">${ele.country}</div>` +
        `<div class=cell id="date">${ele.date}</div>` +
        `<div class=cell id="time">${ele.time}</div>` +
        `<div class=cell id="price">${ele.ticketPrice}</div>` +
        `<div class=cell id="date">${ele.purchaseDate}</div>` +
        `</div>`;
    });
  }
}
function showVouchers(data) {
  var content = document.getElementById("vouchers");
  if (content != null) {
    content.innerHTML = "";
    data.forEach(ele => {
      var used = "";
      if (ele.used == true) {
        used = "Ja";
      }
      else { used = "Nej" }
      content.innerHTML += `<div class="profiletables">` +
        `<div class="cell" id="v_hashtag">${ele.voucherId}</div>` +
        `<div class="cell" id="v_date">${ele.issuedDate}</div>` +
        `<div class="cell" id="v_date">${ele.expiryDate}</div>` +
        `<div class="cell" id="used">${used}</div>` +
        `</div>`;
    });
  }
}
//show-hide pesetas form .
function switchPesetasForm() {
  var pForm = document.getElementById("pesetas_charging");
  if (pForm.style.display == "none" || pForm.style.display == "") {
    pForm.style.display = "block";
  } else {
    pForm.style.display = "none";
  }
}

function buyPesetas(){
  if(document.getElementById("pesetas_form")!=null){
document.querySelector("#pesetas_form button[type='submit']").onclick = function(e){
  if(document.getElementById("value").value >= 50){
  e.preventDefault();
  var kronor = document.getElementById("value").value;
  ajax("php-pages/cus.php", "showResponse",`kronor=${kronor}`);
  reloadContent();
}
}
}
}