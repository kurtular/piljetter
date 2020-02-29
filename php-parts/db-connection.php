<?php
//error_reporting(0);
$servername = "localhost";
$db="piljetter";
$userN = "postgres";
$pass = "1234";

/*customer
$userN = "customer";
$pass = "Um34Kx1bP";
*/

// Create connection
$conn = new PDO('pgsql:host='.$servername.';dbname='.$db, $userN, $pass);
$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
?>