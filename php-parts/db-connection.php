<?php
$servername = "localhost";
$db="piljetter";
$userN = "postgres";
$pass = "1234";

// Create connection
$conn = new PDO('pgsql:host='.$servername.';dbname='.$db, $userN, $pass);
$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
?>