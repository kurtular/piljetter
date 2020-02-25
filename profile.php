<?php
require 'php-parts/login-check.php';
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
    <title>Min sida</title>
</head>
<body>
<?php require 'html-parts/nav.html';?>
    <main>
        <h1>Min sida</h1>
        <h2>Mina biljetter</h2>
        <div class="ticketrow" id="divs_heads">
            <div class="hashtag">ID</div>
            <div class="artist">Artist</div>
            <div class="address">Plats</div>
            <div>Stad</div>
            <div>Land</div>
            <div class="date">Datum</div>
            <div class="time">Tid</div>
            <div class="price">Betalt</div>
            <div class="date">Köpt</div>
        </div>
        <div id="tickets">
        </div>
         <h2>Mina kuponger</h2>
         <div class="voucherrow" id="divs_heads">
            <div class="hashtag">ID</div>
            <div class="date">Utfärdad</div>
            <div class="date">Utgångsdatum</div>
            <div class="used">Använd</div>
        </div>
        <div id="vouchers">
        </div>
    </main>
    <?php include 'html-parts/footer.html';?>
    <a id="toTop" href="#"><i class="fas fa-arrow-up" aria-hidden="true"></i></a>
</body>
</html>