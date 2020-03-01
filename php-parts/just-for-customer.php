<?php
if($_SESSION['userRole']!="customer"){
    http_response_code(404);
    exit();
}

$servername = "localhost";
$db="piljetter";
$userNcustomer = "customer";
$passcustomer = "Um34Kx1bP";

$conn = new PDO('pgsql:host='.$servername.';dbname='.$db, $userNcustomer, $passcustomer);
$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
?>