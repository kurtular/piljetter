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
    createPg("update");
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
                case "createPg": createPg(data); break;
                default:console.log("There are no this option."); ;
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
        case "skapa": create.style.display = "block"; createPg("update"); break;
        case "Statistik": statistic.style.display = "block"; break;
        case "ERD": erd.style.display = "block"; break;
        default: home.style.display = "block"; break;
    }
}
/*concert overview*/
var conOverviewData = "";
function showConOverview(concertId) {
    var conInfo = document.getElementById("concert-info");
    if (concertId == "") {
        conInfo.style.display = "none";
        conInfo.removeAttribute("overview-id");
    } else if (concertId == "show") {
        conInfo.style.display = "block";
    } else if (concertId / 1 == concertId) {
        conInfo.setAttribute("overview-id", concertId);
        conOverview(concertId);
    }
}
function conOverview(data) {
    if (data == "update") {
        if (document.getElementById("concert-info").getAttribute("overview-id")) {
            var concertId = document.getElementById("concert-info").getAttribute("overview-id");
            ajax("php-pages/adm.php", "conOverview", "overview=" + concertId);
        }
    } else if (data / 1 == data) {//in this case data is equals to concertId.
        ajax("php-pages/adm.php", "conOverview", "overview=" + data);
    } else {
        if (JSON.stringify(conOverviewData) != JSON.stringify(data)) {
            document.querySelector("#q-info > .hashtag").innerHTML = document.querySelector(`.concert[item-id='${data.concertId}'] > .hashtag`).innerHTML;
            document.querySelector("#q-info > .artist").innerHTML = document.querySelector(`.concert[item-id='${data.concertId}'] > .artist`).innerHTML;
            document.querySelector("#q-info > .building").innerHTML = document.querySelector(`.concert[item-id='${data.concertId}'] > .building`).innerHTML;
            document.querySelector("#q-info > .address").innerHTML = document.querySelector(`.concert[item-id='${data.concertId}'] > .address`).innerHTML;
            document.querySelector("#q-info > .date").innerHTML = document.querySelector(`.concert[item-id='${data.concertId}'] > .date`).innerHTML;
            document.querySelector("#q-info > .price").innerHTML = document.querySelector(`.concert[item-id='${data.concertId}'] > .price`).innerHTML;
            document.querySelector("#q-info > .amount").innerHTML = data.totalTickets + " totala biljetter.";
            var remainingTickets = data.totalTickets - (data.soldTickets + data.voucherTickets);
            showchart("Kupongersläge.", "#con-tic-pie", "pie", ["Sålda med pesetas.", "Bokade med kuponger", "Antal biljetter kvar."], [data.soldTickets, data.voucherTickets, remainingTickets], ["#75daad", "#f1f3f4", "#f64b3c"], "");
            showchart("Ekonomiskt.", "#con-profit-bar", "bar", ["Kostnaden med pesetas.", "Tjänade pesetas.", "Vinst."], [data.spending, data.earning, data.profit], ["#f64b3c", "#75daad", "#beebe9"], "");
            conOverviewData = data;
            showConOverview("show");
        }
    }
}
/*To create an show a chart */
function showchart(chartTitle, ref, chartType, datalabels, chartData, bkcolors, chartOptions) {
    var disvalue;
    if (chartType == "bar") {
        disvalue = false;
    } else {
        disvalue = true;
    }
    Chart.defaults.global.defaultFontColor = "#fff";
    document.querySelector(ref).removeChild(document.querySelector(ref+">canvas"));
    document.querySelector(ref).appendChild(document.createElement('canvas'));
    var ctx = document.querySelector(ref+">canvas").getContext('2d');
    if (chartOptions == "") { chartOptions = "scales: {yAxes: [{ticks: {beginAtZero: true}}]}"; }
    new Chart(ctx, {
        type: chartType,
        data: {
            labels: datalabels,
            datasets: [{
                data: chartData,
                backgroundColor: bkcolors,
                borderWidth: 1
            }]
        },
        options: { aspectRatio: 1.2, responsive: true, legend: { display: disvalue, position: 'top' }, title: { display: true, text: chartTitle } }
    });
}
/*Create subpage functions */
/*createPg() Makes create subpage up to date*/
var glArtistsL = "";
var glScenesL = "";
var glCitiesL = "";
function createPg(data) {
    if (document.getElementById("CREATE").style.display == "block") {
        if (data == "update") {
            ajax("php-pages/adm.php", "createPg", "createPg");
        } else {
            if (JSON.stringify(glArtistsL) != JSON.stringify(data.artistsL)) {
                var artistsL = document.getElementById("new-conc-artist");
                var result = "";
                data.artistsL.forEach(ele => {
                    result += `<option value="${ele.id}">${ele.value}</option>`
                });
                artistsL.innerHTML = '<option disabled selected value="">Välja en artist</option>' + result;
                glArtistsL = data.artistsL;
            }
            if (JSON.stringify(glScenesL) != JSON.stringify(data.scenesL)) {
                var scenesL = document.getElementById("new-conc-scene");
                var result = "";
                data.scenesL.forEach(ele => {
                    result += `<option value="${ele.id}">${ele.value}</option>`;
                });
                scenesL.innerHTML = '<option disabled selected value="">Välja en scene</option>' + result;
                glScenesL = data.scenesL;
            }
            if (JSON.stringify(glCitiesL) != JSON.stringify(data.citiesL)) {
                var citiesL = document.getElementById("new-sce-city");
                var result = "";
                data.citiesL.forEach(ele => {
                    result += `<option value="${ele.id}">${ele.value}</option>`;
                });
                citiesL.innerHTML = '<option disabled selected value="">Välja en stad</option>' + result;
                glCitiesL = data.citiesL;
            }
        }
    }
}
function shRange(data) {
    switch (data) {
        case "rate": document.getElementById("rate-value").innerHTML = document.getElementById("ny-sce-rate").value; break;
        case "popu": document.getElementById("popularity-value").innerHTML = document.getElementById("ny-art-popularity").value; break;
        default: console.log("Check me out something is wrong.");
    }
}

window.addEventListener("load", function () {
    document.querySelector("#admin_form button[type='submit']").onclick = function (e) {
        if (isRequiredDone(document.querySelectorAll("#admin_form *[required]"))) {
            e.preventDefault();
            createSubmit("createAdmin");
        }
    };
    document.querySelector("#city_form button[type='submit']").onclick = function (e) {
        if (isRequiredDone(document.querySelectorAll("#city_form *[required]"))) {
            e.preventDefault();
            createSubmit("addCity");
        }
    };
    document.querySelector("#scene_form button[type='submit']").onclick = function (e) {
        if (isRequiredDone(document.querySelectorAll("#scene_form *[required]"))) {
            e.preventDefault();
            createSubmit("addScene");
        }
    };
    document.querySelector("#artist_form button[type='submit']").onclick = function (e) {
        if (isRequiredDone(document.querySelectorAll("#artist_form *[required]"))) {
            e.preventDefault();
            createSubmit("addArtist");
        }
    };
    document.querySelector("#concert_form button[type='submit']").onclick = function (e) {
        if (isRequiredDone(document.querySelectorAll("#concert_form *[required]"))) {
            e.preventDefault();
            createSubmit("addConcert");
        }
    };
});
function isRequiredDone(elements) {
    var returned = true;
    elements.forEach(element => {
        if (element.value == "") {
            returned = false;
        }
    });
    return returned;
}
function createSubmit(data) {
    if (window.confirm("Är du säker om att skicka datan vidare till databasen?\n !!Notera att du kan ändra det sen på nu läge!!")) {
        switch (data) {
            case "addConcert":
                var artId = document.getElementById("new-conc-artist").value;
                var sceId = document.getElementById("new-conc-scene").value;
                var remTic = document.getElementById("new-conc-tickets").value;
                var date = document.getElementById("new-con-date").value;
                var time = document.getElementById("new-con-time").value;
                ajax("php-pages/adm.php", "showResponse", `addConcert&artId=${artId}&sceId=${sceId}&remTic=${remTic}&date=${date}&time=${time}`);
                ; break;
            case "addArtist":
                var name = document.getElementById("new-art-name").value;
                var pop = document.getElementById("ny-art-popularity").value;
                ajax("php-pages/adm.php", "showResponse", `addArtist&name=${name}&pop=${pop}&`);
                ; break;
            case "addScene":
                var name = document.getElementById("new-sce-name").value;
                var rate = document.getElementById("ny-sce-rate").value;
                var cap = document.getElementById("new-sce-capacity").value;
                var address = document.getElementById("new-sce-address").value;
                var zip = document.getElementById("new-art-zip").value;
                var cityId = document.getElementById("new-sce-city").value;
                ajax("php-pages/adm.php", "showResponse", `addScene&name=${name}&rate=${rate}&cap=${cap}&address=${address}&zip=${zip}&cityId=${cityId}`);
                ; break;
            case "addCity":
                var city = document.getElementById("new-city").value;
                var country = document.getElementById("new-country").value;
                ajax("php-pages/adm.php", "showResponse", `addCity&city=${city}&country=${country}`);
                ; break;
            case "createAdmin":
                var fname = document.getElementById("new-adm-firstname").value;
                var lname = document.getElementById("new-adm-lastname").value;
                var email = document.getElementById("new-adm-email").value;
                var uname = document.getElementById("new-adm-username").value;
                var psw = document.getElementById("new-adm-password").value;
                var repsw = document.getElementById("new-adm-repassword").value;
                if (psw == repsw) {
                    ajax("php-pages/adm.php", "showResponse", `createAdmin&fname=${fname}&lname=${lname}&email=${email}&uname=${uname}&psw=${psw}`);
                } else {
                    window.alert("!!Repeterande lösenordet stämmer inte!!");
                }
                ; break;
            default: console.log("Check me out something is wrong.");
        }
        createPg("update");
    }
}