<?php
require '../php-parts/login-check.php';
require '../php-parts/db-connection.php';
require '../php-parts/obj.php';
// get search filter data
if(isset($_POST["filter"])){
    $sql="SELECT DISTINCT country FROM cities ORDER BY country";
$stmt = $conn->prepare($sql);
$stmt->execute();
$countries = [];
$i=0;
while($row = $stmt->fetch(PDO::FETCH_ASSOC)){
$countries[$i] = $row['country'];
$i++;
}
    $sql="SELECT DISTINCT city FROM cities ORDER BY city";
    $stmt = $conn->prepare($sql);
    $stmt->execute();
    $cities = [];
    $i=0;
while($row = $stmt->fetch(PDO::FETCH_ASSOC)){
    $cities[$i] = $row['city'];
    $i++;
}
$sql="SELECT DISTINCT name FROM scenes ORDER BY name";
$stmt = $conn->prepare($sql);
$stmt->execute();
$secens = [];
$i=0;
while($row = $stmt->fetch(PDO::FETCH_ASSOC)){
$secens[$i] = $row['name'];
$i++;
}
echo '{"countries":';
echo json_encode($countries,JSON_PRETTY_PRINT);
echo ',"cities":';
echo json_encode($cities,JSON_PRETTY_PRINT);
echo ',"scenes":';
echo json_encode($secens,JSON_PRETTY_PRINT);
echo "}";
exit();
}
// get all concerts data,

//get filtering data
$filter="";
if(isset($_POST["artist"]) && $_POST["artist"]!=""){
    $filter .="AND UPPER(a.name) LIKE UPPER('%$_POST[artist]%') ";
}
if(isset($_POST["country"]) && $_POST["country"]!=""){
    $filter .="AND UPPER(ci.country)=UPPER('$_POST[country]') ";
}
if(isset($_POST["city"]) && $_POST["city"]!=""){
    $filter .="AND UPPER(ci.city)=UPPER('$_POST[city]') ";
}
if(isset($_POST["scene"]) && $_POST["scene"]!=""){
    $filter .="AND UPPER(s.name)=UPPER('$_POST[scene]') ";
}
if(isset($_POST["date"]) && $_POST["date"]!=""){
    $filter .="AND c.date='$_POST[date]' ";
}
if(isset($_POST["fDate"]) && $_POST["fDate"]!=""){
    $filter .="AND c.date>='$_POST[fDate]' ";
}
if(isset($_POST["lDate"]) && $_POST["lDate"]!=""){
    $filter .="AND c.date<='$_POST[lDate]' ";
}
//starting getting concerts from db
$sql= "SELECT c.concert_id,a.name AS artist_name,s.name AS scene_name,s.address,concat(ci.city,' , ',ci.country) AS city,c.date,c.time,c.ticket_price,c.remaining_tickets
FROM concerts AS c,artists AS a,scenes AS s,cities AS ci 
WHERE c.artist_id = a.artist_id AND c.scene_id = s.scene_id AND s.city_id= ci.city_id AND c.cancelled = false AND c.date+c.time > current_date+current_time $filter ORDER BY c.date+c.time ASC;";

$stmt = $conn->prepare($sql);
$stmt->execute();
$concerts = [];
$i=0;
while($row = $stmt->fetch(PDO::FETCH_ASSOC)){
    $concerts[$i] = new concert($row['concert_id'],$row['artist_name'],$row['scene_name'],$row['address'],$row['city'],$row['date'],$row['time'],$row['ticket_price'],$row['remaining_tickets']);
    $i++;
}
//printing result as json
echo '{"concerts":';
echo json_encode($concerts,JSON_PRETTY_PRINT);
echo "}";
$conn =null;
$stmt =null;
?>