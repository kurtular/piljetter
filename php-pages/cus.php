<?php
header("Content-type: application/json; charset=utf-8");
require '../php-parts/login-check.php';
require '../php-parts/obj.php';
require '../php-parts/just-for-customer.php';
if(isset($_POST["itemId"]) && $_POST["itemId"]!=""){
    if(isset($_POST["vouchId"]) && $_POST["vouchId"]!=""){
        $sql= "SELECT buy_tickets_with_voucher($_POST[itemId],$_SESSION[userId],$_POST[vouchId]);";
    }else{
        $sql= "SELECT buy_tickets_with_pesetas($_POST[itemId],$_SESSION[userId]);";
    }
    $stmt = $conn->prepare($sql);
    try{
    $stmt->execute();
    echo '{"msg":"Det gick bra med att köpa biljetten.!! Ha det roligt !!"}';
    }catch(Exception $e){
        if(strpos($stmt->errorInfo()[2],"Du har inte tillräckligt pesetas")){
            echo '{"msg":"Tyvärr! Det gick inte att köpa biljetten. !!Du har inte tillräckligt pesetas!!"}';
        }else if(strpos($stmt->errorInfo()[2],"Denna kupong id är ogiltigt.")){
            echo '{"msg":"Tyvärr! Det gick inte att köpa biljetten.Denna kupong id är ogiltigt."}';
        }else if(strpos($stmt->errorInfo()[2],"Denna kupong är ogiltigt längre.")){
            echo '{"msg":"Tyvärr! Det gick inte att köpa biljetten.Denna kupong är ogiltigt längre."}';
        }else
        echo '{"msg":"Tyvärr! Det gick inte att köpa biljetten."}';
    }
    exit();
}
if(isset($_POST["kronor"]) && $_POST["kronor"]!=""){
    $sql= "SELECT pesetas_charging_function($_SESSION[userId],$_POST[kronor]);";
    $stmt = $conn->prepare($sql);
    $stmt->execute();
    $row = $stmt->fetch(PDO::FETCH_ASSOC);
    if(isset($row['msg']) && $row['msg']!=""){
        $msg = '{"msg":"'.$row['msg'].'"}';
        echo $msg;
    }else{
        echo  '{"msg":"Deposit success!"}';
    }
    exit();
}
//get user information
$sql= "SELECT concat(u.first_name,' ',u.last_name) AS NAME,w.balance FROM users AS u,wallets AS w WHERE u.user_id=w.user_id AND u.user_id = $_SESSION[userId]";
$stmt = $conn->prepare($sql);
$stmt->execute();
//should return just one row.
$row = $stmt->fetch(PDO::FETCH_ASSOC);
$user= new user($row['name'],$row['balance']);
//Showing the tickets in customerpage
$sql ="SELECT * FROM get_tickets($_SESSION[userId])";
$stmt = $conn->prepare($sql);
$stmt->execute();
$tickets = array();
$i=0;
while($row = $stmt->fetch(PDO::FETCH_ASSOC)){
    $tickets[$i] = new ticket($row['ticket_id'],$row['artist_name'],$row['scene_name'],$row['city'],$row['country'],$row['date'],$row['time'],$row['ticket_price'],$row['purchase_date'],$row['vouchered']);
    $getDate =$tickets{$i}->purchaseDate;
    $createDate = new DateTime($getDate);
    $dateObj = $createDate->format("Y-m-d");
    $tickets{$i}->purchaseDate = $dateObj;
    $i++;
}
//Showing the vouchers
$sql ="SELECT voucher_id, issued_date, expire_date, used from vouchers WHERE vouchers.user_id = $_SESSION[userId];";
$stmt = $conn->prepare($sql);
$stmt->execute();
$vouchers = array();
$i=0;
while($row = $stmt->fetch(PDO::FETCH_ASSOC)){
    $vouchers[$i] = new voucher($row['voucher_id'],$row['issued_date'],$row['expire_date'],$row['used']);
    $i++;
}

//printing result as json
echo '{"user":';
echo json_encode($user,JSON_PRETTY_PRINT);
echo ',"tickets":';
echo json_encode($tickets,JSON_PRETTY_PRINT);
echo ',"vouchers":';
echo json_encode($vouchers,JSON_PRETTY_PRINT);
echo "}";
$conn =null;
$stmt =null;
?>