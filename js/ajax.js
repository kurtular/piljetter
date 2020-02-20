window.onload = function(){
reLoadContent();
setInterval(reLoadContent,5000);
};
function reLoadContent() {
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
      if (this.readyState == 4 && this.status == 200) {
        show_concerts(JSON.parse(this.responseText));
      }
    };
    xhttp.open("GET", "php-pages/cus.php", true);
    xhttp.send();
  }
  function show_concerts(data){
    var content = document.getElementById("content");
    content.innerHTML="";
    data.forEach(ele => {
        content.innerHTML+=`<div class="concert" item-id="${ele.concertId}">`+
        `<div class="artist">${ele.artistName}.</div>`+
        `<div class="building">${ele.sceneName}.</div>`+
        `<div class="address">${ele.address}</div>`+
        `<div class="date">${ele.date} ${ele.time}</div>`+
        `<div class="price">${ele.ticketPrice}</div>`+
        `<div class="amount">${ele.remainingTickets} biljetter kvar.</div>`+
        `<i class="fas fa-cart-plus addToCart"></i>`+
        `</div>`;
    });
  }
