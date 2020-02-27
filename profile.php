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
        <div class="ticketrow" id="divs_heads">
            <div class="hashtag" style="margin-left:-1vw;" >ID</div>
            <div class="artist" style="margin-left:7vw;">Artist</div>
            <div class="building"style="margin-left:19vw;">Plats</div>
            <div class="address">Stad</div>
            <div class="country">Land</div>
            <div class="date">Datum</div>
            <div class="time">Tid</div>
            <div class="price"style="margin-left:53vw;">Betalt</div>
            <div class="date">Köpt</div>
        </div>
        <div id="tickets">
        </div>
        <h2>Mina kuponger</h2>
        <div class="voucherrow" id="divs_heads">
            <div class="hashtag">ID</div>
            <div class="date">Utfärdad</div>
            <div class="date"style="margin-left:38vw;">Utgångsdatum</div>
            <div class="used"style="margin-left:53vw;">Förbrukad</div>
        </div>
        <div id="vouchers">
        </div>
    </main>
    <div id="pesetas_charging">
        <div>
        <form id="pesetas_form">
            <img src="img/logo.png">
            <h1>Här köper du pesetas!</h1>
            <h2>1 pesetas = 2 kronor</h2>
            <div>
                <div>
                    <label for="pesetas"><b>Välj antal pesetas</b></label>
                    <input type="number" name="pesetas" placeholder="" required autocomplete="off">
                </div>
                <div>
                    <label for="cardnumber"><b>Kortnummer</b></label>
                    <input type="number" name="cardnumber" placeholder="" required>
                </div>
                <div>
                    <label for="cardholder_firstname"><b>Förnamn</b></label>
                    <input type="text" name="cardholder_firstname" placeholder="" required>
                </div>
                <div>
                    <label for="cardholder_surname"><b>Efternamn</b></label>
                    <input type="text" name="cardholder_surname" placeholder="" required autocomplete="off">
                </div>
                <div>
                    <label for="expirydate"><b>Utgångsdatum</b></label>
                    <input type="number" name="expirydate" placeholder="" required autocomplete="off">
                </div>
                <div>
                    <label for="cvv"><b>CVV</b></label>
                    <input type="number" name="cvv" placeholder="" required autocomplete="off">
                </div>
            </div>
            <button name=purchase type="submit" value="purchase">Köp</button>
            <a onclick="switchPesetasForm()">Tillbaka</a>
        </form>
        </div>
    </div>
    <?php include 'html-parts/footer.html';?>
    <a id="toTop" href="#"><i class="fas fa-arrow-up" aria-hidden="true"></i></a>
</body>
</html>