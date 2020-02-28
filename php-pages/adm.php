<?php
header("Content-type: application/json; charset=utf-8");
require '../php-parts/login-check.php';
require '../php-parts/db-connection.php';
require '../php-parts/obj.php';
require '../php-parts/just-for-admin.php';
if(isset($_POST["cancelCon"]) && $_POST["cancelCon"]!="" && isset($_POST["extra"]) && $_POST["extra"]!=""){
    $sql= "SELECT cancel_concert($_POST[cancelCon],$_POST[extra])";
    $stmt = $conn->prepare($sql);
    try{
        $stmt->execute();
        echo '{"msg":"Konsert som har id: '.$_POST["cancelCon"].' är inställd."}';
    }catch(Exception $e){
        echo '{"msg":"Det gick inte att inställa konserten som har id: '.$_POST["cancelCon"].'."}';
    }
    exit();
}
//show data
if(isset($_POST["overview"]) && $_POST["overview"]!=""){
    $sql= "SELECT * FROM concerts_profit_statistic WHERE concert_id= $_POST[overview]";
    $stmt = $conn->prepare($sql);
    $stmt->execute();
    //should return just one row.
    $row = $stmt->fetch(PDO::FETCH_ASSOC);
    $overView = new OverView($row['concert_id'],$row['spending'],$row['earning'],$row['profit'],$row['total_amount_tickets'],$row['sold_tickets'],$row['voucher_tickets']);
    echo json_encode($overView,JSON_PRETTY_PRINT);
    exit();
}
//get user information
$sql= "SELECT concat(u.first_name,' ',u.last_name) AS NAME FROM users AS u WHERE u.user_id = $_SESSION[userId]";
$stmt = $conn->prepare($sql);
$stmt->execute();
//should return just one row.
$row = $stmt->fetch(PDO::FETCH_ASSOC);
$user= new user($row['name'],"");
//printing result as json
echo '{"user":';
echo json_encode($user,JSON_PRETTY_PRINT);
echo "}";
$conn =null;
$stmt =null;
?>