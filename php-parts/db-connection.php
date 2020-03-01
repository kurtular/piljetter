<?php
//error_reporting(0);
$servername = "localhost";
$db="piljetter";
$userN = "admin";
$pass = "t6Bnw9UYa";

/*
$userN = "admin";
$pass = "t6Bnw9UYa";
 */


// Create connection
$conn = new PDO('pgsql:host='.$servername.';dbname='.$db, $userN, $pass);
$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
?>