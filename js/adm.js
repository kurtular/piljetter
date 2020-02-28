window.addEventListener("load", function () {
    reloadContent();
    setInterval(reloadContent, 10000);
});

function reloadContent() {
    if (document.getElementById("search-bar") != null) {
        ajax("php-pages/search.php", "showConcerts", concertsFilter);
    }
    ajax("php-pages/adm.php", "showUserN", "");
    conOverview("update");
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
                case "conOverview": conOverview(data); break;
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
                first = `<div item-id="${ele.concertId}" class="concert passedcancelled"><div class="con-cancelled">Inställed</div>`;
            } else if (ele.passed) {
                first = `<div item-id="${ele.concertId}" class="concert passed"><br>`;
            } else if (ele.cancelled) {
                first = `<div item-id="${ele.concertId}" class="concert cancelled"><div class="con-cancelled">Inställed</div>`;
            } else {
                first = `<div item-id="${ele.concertId}" class="concert"><br>`;
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
                `<i onclick="showConOverview(${ele.concertId})" class="fas fa-exclamation con-option con-info"></i>` +
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
function show(obj) {
    var home = document.querySelector("main");
    var create = document.getElementById("CREATE");
    var statistic = document.getElementById("STATISTIC");
    var erd = document.getElementById("ERD");

    document.querySelectorAll("nav>a")[0].classList.remove("selected");
    document.querySelectorAll("nav>a")[1].classList.remove("selected");
    document.querySelectorAll("nav>a")[2].classList.remove("selected");
    document.querySelectorAll("nav>a")[3].classList.remove("selected");
    obj.classList.add("selected");

    home.style.display = "none";
    create.style.display = "none";
    statistic.style.display = "none";
    erd.style.display = "none";
    switch (obj.innerHTML) {
        case "Hem": home.style.display = "block"; break;
        case "skapa": create.style.display = "block"; break;
        case "Statistik": statistic.style.display = "block"; break;
        case "ERD": erd.style.display = "block"; break;
        default: home.style.display = "block"; break;
    }
}
/*concert overview*/
var conOverviewData ="";
function showConOverview(concertId) {
    var conInfo = document.getElementById("concert-info");
    if (concertId == "") {
        conInfo.style.display = "none";
        conInfo.removeAttribute("overview-id");
    } else if (concertId == "show") {
        conInfo.style.display = "block";
    } else if(concertId/1==concertId){
        conInfo.setAttribute("overview-id", concertId);
        conOverview(concertId);
    }
}
function conOverview(data) {
    if (data == "update") {
        if (document.getElementById("concert-info").getAttribute("overview-id")) {
            var concertId = document.getElementById("concert-info").getAttribute("overview-id");
            ajax("php-pages/adm.php", "conOverview", "overview="+concertId);
        }
    } else if (data / 1 == data) {//in this case data is equals to concertId.
        ajax("php-pages/adm.php", "conOverview", "overview="+data);
    } else {
        if(JSON.stringify(conOverviewData)!=JSON.stringify(data)){
            document.querySelector("#q-info > .hashtag").innerHTML = document.querySelector(`.concert[item-id='${data.concertId}'] > .hashtag`).innerHTML;
            document.querySelector("#q-info > .artist").innerHTML = document.querySelector(`.concert[item-id='${data.concertId}'] > .artist`).innerHTML;
            document.querySelector("#q-info > .building").innerHTML = document.querySelector(`.concert[item-id='${data.concertId}'] > .building`).innerHTML;
            document.querySelector("#q-info > .address").innerHTML = document.querySelector(`.concert[item-id='${data.concertId}'] > .address`).innerHTML;
            document.querySelector("#q-info > .date").innerHTML = document.querySelector(`.concert[item-id='${data.concertId}'] > .date`).innerHTML;
            document.querySelector("#q-info > .price").innerHTML = document.querySelector(`.concert[item-id='${data.concertId}'] > .price`).innerHTML;
            document.querySelector("#q-info > .amount").innerHTML = data.totalTickets+" totala biljetter.";
            var remainingTickets=data.totalTickets-(data.soldTickets+data.voucherTickets);
            showchart("Kupongersläge.","#con-tic-pie>canvas","pie",["Sålda med pesetas.","Bokade med kuponger","Antal biljetter kvar."],[data.soldTickets,data.voucherTickets,remainingTickets],["#75daad","#f1f3f4","#f64b3c"],"");
            showchart("Ekonomiskt.","#con-profit-bar>canvas","bar",["Kostnaden med pesetas.","Tjänade pesetas.","Vinst."],[data.spending,data.earning,data.profit],["#f64b3c","#75daad","#beebe9"],"");
            conOverviewData=data;
            showConOverview("show");
        }
    }
}
function showchart(chartTitle,ref,chartType,datalabels,chartData,bkcolors,chartOptions){
    var disvalue;
    if(chartType=="bar"){
        disvalue=false;
    }else{
        disvalue=true; 
    }
    Chart.defaults.global.defaultFontColor = "#fff";
    var ctx = document.querySelector(ref).getContext('2d');
    if(chartOptions==""){chartOptions="scales: {yAxes: [{ticks: {beginAtZero: true}}]}";}
var myChart = new Chart(ctx, {
    type: chartType,
    data: {
        labels: datalabels,
        datasets: [{
            data: chartData,
            backgroundColor: bkcolors,
            borderWidth: 1
        }]
    },
    options: {aspectRatio:1.2,responsive: true,legend:{display:disvalue,position: 'top'},title: {display: true,text:chartTitle}}
});
}