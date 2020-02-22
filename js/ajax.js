window.addEventListener("load",function(){
reLoadContent();
setInterval(reLoadContent,10000);
});

function reLoadContent() {
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
      if (this.readyState == 4 && this.status == 200) {
        var data = JSON.parse(this.responseText);
        showUserNb(data.user);
        show_concerts(data.concerts);
      }
    };
    xhttp.open("GET", "php-pages/cus.php", true);
    xhttp.send();
  }
  function show_concerts(data){
    var content = document.getElementById("content");
    var newContent="";
    data.forEach(ele => {
      newContent+=`<div class="concert" item-id="${ele.concertId}">`+
        `<div class="artist">${ele.artistName}.</div>`+
        `<div class="building">${ele.sceneName}.</div>`+
        `<div class="address">${ele.address}</div>`+
        `<div class="date">${ele.date} ${ele.time}</div>`+
        `<div class="price">${ele.ticketPrice}</div>`+
        `<div class="amount">${ele.remainingTickets} biljetter kvar.</div>`+
        `<i class="fas fa-cart-plus addToCart"></i>`+
        `</div>`;
    });
    if(newContent!=content.innerHTML){
      content.innerHTML = newContent;
    }
  }
  function showUserNb(data){
    var userName = document.querySelector("#user-name");
    var userBalance = document.querySelector("#user-balance");
    if(data.name!=userName.innerHTML && userBalance.innerHTML != data.balance){
      userName.innerHTML = data.name;
      userBalance.innerHTML = data.balance;
    }
  }