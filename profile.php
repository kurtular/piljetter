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
        <div class="tickets" id="divs_heads">
            <div class="artist">Artist</div>
            <div class="address">Plats</div>
            <div class="date">Datum/tid</div>
            <div class="price">Betalt</div>
            <div class="amount">Kupong</div>
            <div class="date">Inköpsdatum</div>
            
        </div>
        <div class="tickets" id="tickets">
            <div>Madonna</div>
            <div>Ullevi</div>
            <div>2020-05-23 20:00</div>
            <div>700</div>
            <div>Nej</div>
            <div>2020-02-07</div>
            
        </div>
        <div class="tickets" id="tickets">
            <div>Eminem</div>
            <div>Parken</div>
            <div>2020-08-23 15:00</div>
            <div>0</div>
            <div>Ja</div>
            <div>2020-01-27</div>
         </div>
         <h2>Mina kuponger</h2>
         <div class="vouchers" id="divs_heads">
            <div class="hashtag">ID</div>
            <div class="date">Utfärdad</div>
            <div class="date">Utgångsdatum</div>
            <div class="used">Använd</div>
        </div>
        <div class="vouchers">
            <div>983734</div>
            <div>2019-05-22</div>
            <div>2020-05-22</div>
            <div>nej</div>
        </div>
    </main>
    <?php include 'html-parts/footer.html';?>
    <a id="toTop" href="#"><i class="fas fa-arrow-up" aria-hidden="true"></i></a>
</body>
</html>