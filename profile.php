<?php
require 'php-parts/login-check.php';
require 'php-parts/just-for-customer.php';
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link rel="shortcut icon" href="img/icon.png" type="image/x-icon">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.1/css/all.css">
    <link href="https://fonts.googleapis.com/css?family=Fugaz+One|Lato|Nova+Flat|Sofia&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/nav.css">
    <script src="js/cus.js"></script>
    <link rel="stylesheet" href="css/profile.css">
    <link rel="stylesheet" href="css/nav.css">
    <link rel="stylesheet" href="css/footer.css">
    <link rel="stylesheet" href="css/pesetas.css">
    <title>Min sida</title>
</head>

<body>
    <?php require 'html-parts/nav.html';?>
    <main>
        <button id="addpesetas" onclick="switchPesetasForm()"><i class="fas fa-coins"></i>Fyll på pesetas</button>
        </div>
        <h1>Min sida</h1>
        <h2>Mina biljetter</h2>
        
        <div class="profiletables" id="tickethead">
            <div class="cell" id="hashtag">ID</div>
            <div class="cell" id="artist">Artist</div>
            <div class="cell" id="building">Plats</div>
            <div class="cell" id="address">Stad</div>
            <div class="cell" id="country">Land</div>
            <div class="cell" id="date">Datum</div>
            <div class="cell" id="time">Tid</div>
            <div class="cell" id="price">Betalt</div>
            <div class="cell" id="date">Köpt</div>
        </div>
        <div id="tickets">
        </div>

        <h2>Mina kuponger</h2>
        <div class="profiletables" id="voucherhead">
            <div class="cell"id="v_hashtag">ID</div>
            <div class="cell"id="v_date">Utfärdad</div>
            <div class="cell"id="v_date">Utgångsdatum</div>
            <div class="cell"id="used">Förbrukad</div>
        </div>
        <div id="vouchers">
        </div>
    </main>
    <div id="pesetas_charging">
        <div>
        <form id="pesetas_form">
            <img src="img/logo.png">
            <h1>Här köper du pesetas!</h1>
            <h2>1 krona = 2 pesetas (minsta insättning 50 kronor)</h2>
            <h3>Under utveckling! Endast beloppet fungerar</h3>
            <div>
                <div>
                    <label><b>Välj belopp i kronor</b></label>
                    <input type="number" id="value" min="50" required>
                </div>
                <div>
                    <label><b>Kortnummer</b></label>
                    <input type="number">
                </div>
                <div>
                    <label><b>Förnamn</b></label>
                    <input type="text">
                </div>
                <div>
                    <label><b>Efternamn</b></label>
                    <input type="text">
                </div>
                <div>
                    <label><b>Utgångsdatum</b></label>
                    <input type="number">
                </div>
                <div>
                    <label><b>CVV</b></label>
                    <input type="number">
                </div>
            </div>
            <button name=purchase type="submit" >Köp</button>
            <a onclick="switchPesetasForm()">Tillbaka</a>
        </form>
        </div>
    </div>
    <?php include 'html-parts/footer.html';?>
    <a id="toTop" href="#"><i class="fas fa-arrow-up" aria-hidden="true"></i></a>
</body>
</html>