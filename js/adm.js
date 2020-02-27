window.addEventListener("load", function () {
    reloadContent();
    setInterval(reloadContent, 10000);
});

function reloadContent() {
    if (document.getElementById("search-bar") != null) {
        ajax("php-pages/search.php", "showConcerts", concertsFilter);
    }
    ajax("php-pages/adm.php", "showUserN", "");
}
function ajax(link, methodToCall, post) {
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            var data = JSON.parse(this.responseText);
            // TO check which action will be done.
            switch (methodToCall) {
                case "showUserN": showUserN(data.user); break;
                case "showConcerts": showConcerts(data.concerts); break;
                case "showResponse": alert(data.msg); break;
                default: ;
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
            var first = "", last = "";
            if (ele.passed && ele.cancelled) {
                first = `<div class="concert passedcancelled"><div class="con-cancelled">Inställed</div>`;
            } else if (ele.passed) {
                first = `<div class="concert passed"><br>`;
            } else if (ele.cancelled) {
                first = `<div class="concert cancelled"><div class="con-cancelled">Inställed</div>`;
            } else {
                first = `<div class="concert"><br>`;
                last = `<i onclick="cancel(${ele.concertId})" class="fas fa-times con-option con-cancell"></i>`;
            }
            newContent += first +
                `<div class="hashtag">${ele.concertId}</div>` +
                `<div class="artist">${ele.artistName}.</div>` +
                `<div class="building">${ele.sceneName}.</div>` +
                `<div class="address">${ele.address}<div class="city-country">${ele.city}</div></div>` +
                `<div class="date">${ele.date} ${ele.time}</div>` +
                `<div class="price">${ele.ticketPrice}</div>` +
                `<div class="amount">${ele.remainingTickets} biljetter kvar.</div><div class="con-con">` +
                `<i onclick="info(${ele.concertId})" class="fas fa-exclamation con-option con-info"></i>` +
                last + `</div></div>`;
        });
        if (newContent != content.innerHTML) {
            content.innerHTML = newContent;
        }
    }
}
function showUserN(data) {
    var userName = document.querySelector("#user-name");
    if (data.name != userName.innerHTML) {
        userName.innerHTML = data.name;
    }
}
function cancel(concertId) {
    if (concertId != null && window.confirm(`Är du säker om att inställa \n konserten som har id: ${concertId}?\n !!Notera att betalda pesetas ska skickas tillbaka och förbrukat kuponger ska ersättas!!`)) {
        var extra = window.confirm("Skulle du ge ut dem som betalade med pesetas en kupong som extra ersättning?\n !!Notera att pesetas ska skickas tillbaka i alla fall!!");
        ajax("php-pages/adm.php", "showResponse", `cancelCon=${concertId}&extra=${extra}`);
        reloadContent();
    }
}