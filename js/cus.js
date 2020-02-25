window.addEventListener("load", function () {
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

//todo
function buy(itemId) {
  if (itemId != null && window.confirm('Är du säker om att köpa en biljett?')) {
    if(window.confirm("Skulle du använda en kupong för det?")){
      var voucherId;
      voucherId=window.prompt("Inmata gärna din kupong id");
      ajax("php-pages/cus.php", "showResponse",`itemId=${itemId}&vouchId=${voucherId}`);
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
      content.innerHTML += `<div class="ticketrow">` +
        `<div>${ele.ticketId}</div>` +
        `<div>${ele.artistName}</div>` +
        `<div>${ele.sceneName}</div>` +
        `<div>${ele.city}</div>` +
        `<div>${ele.country}</div>` +
        `<div>${ele.date}</div>` +
        `<div>${ele.time}</div>` +
        `<div>${ele.ticketPrice}</div>` +
        `<div>${ele.purchaseDate}</div>` +
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
      content.innerHTML += `<div class="voucherrow">` +
        `<div>${ele.voucherId}</div>` +
        `<div>${ele.issuedDate}</div>` +
        `<div>${ele.expiryDate}</div>` +
        `<div>${used}</div>` +
        `</div>`;
    });
  }
}