<?php
require '../php-parts/login-check.php';
require '../php-parts/db-connection.php';
require '../php-parts/obj.php';
// get all concerts data
$sql= "SELECT c.concert_id,a.name AS artist_name,s.name AS scene_name,s.address,concat(ci.city,' , ',ci.country) AS city,c.date,c.time,c.ticket_price,c.remaining_tickets
FROM concerts AS c,artists AS a,scenes AS s,cities AS ci 
WHERE c.artist_id = a.artist_id AND c.scene_id = s.scene_id AND s.city_id= ci.city_id AND c.cancelled = false AND c.date+c.time > current_date+current_time ORDER BY c.date+c.time ASC;";
$stmt = $conn->prepare($sql);
$stmt->execute();
$concerts = [];
$i=0;
while($row = $stmt->fetch(PDO::FETCH_ASSOC)){
    $concerts[$i] = new concert($row['concert_id'],$row['artist_name'],$row['scene_name'],$row['address'],$row['city'],$row['date'],$row['time'],$row['ticket_price'],$row['remaining_tickets']);
    $i++;
}
//get user information
$sql= "SELECT concat(u.first_name,' ',u.last_name) AS NAME,w.balance FROM users AS u,wallets AS w WHERE u.user_id=w.user_id AND u.user_id = $_SESSION[userId]";
$stmt = $conn->prepare($sql);
$stmt->execute();
//should return just one row.
$row = $stmt->fetch(PDO::FETCH_ASSOC);
$user= new user($row['name'],$row['balance']);




//printing result as json
echo '{"user":';
echo json_encode($user,JSON_PRETTY_PRINT);
echo ',"concerts":';
echo json_encode($concerts,JSON_PRETTY_PRINT);
echo "}";
$conn =null;
$stmt =null;
?>