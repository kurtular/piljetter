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
    <link rel="stylesheet" href="css/c-h.css">
    <link rel="stylesheet" href="css/nav.css">
    <link rel="stylesheet" href="css/footer.css">
    <script src="js/c-h.js"></script>
    <script src="js/ajax.js"></script>
    <title>hemsida</title>
</head>
<body>
    <?php require 'html-parts/nav.html';?>
    <main>
        <header>
            <div id="search-bar">
                <input type="text" placeholder="Skriv in artist namn">
                <i class="fas fa-search"></i>
                <button id="filter-button"><i class="fas fa-caret-down"></i>Filter</button>
            </div>
            <div id="filter">
                <select id="">
                    <option disabled selected>Välja ett land</option>
                </select>
                <select id="">
                    <option disabled selected>Välja en stad</option>
                </select>
                <select id="">
                    <option disabled selected>Välja en scene</option>
                </select><br>
                <div class="date-input">
                    <label for="date">En viss datum</label><br>
                    <input type="date" name="" id="f-date"></div><br>
                <div class="date-input">
                    <label for="f-date">Från och med</label><br>
                    <input type="date" name="f-date" id="">
                </div>
                <div class="date-input">
                    <label for="l-date">Till och med</label><br>
                    <input type="date" name="l-date" id="">
                </div>
            </div>

        </header>
        <div id="content">
        </div>
    </main>
    <?php include 'html-parts/footer.html';?>
    <a id="toTop" href="#"><i class="fas fa-arrow-up" aria-hidden="true"></i></a>
</body>
</html>