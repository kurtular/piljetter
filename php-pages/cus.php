<?php
require '../php-parts/login-check.php';
require '../php-parts/db-connection.php';
require '../php-parts/obj.php';
//concerts (concert_id,artist_namn,plats name,address,date,ticket_price,remaining_tickets);
$sql= "SELECT c.concert_id,a.name AS artist_name,s.name AS scene_name,s.address,concat(ci.city,' , ',ci.country) AS city,c.date,c.time,c.ticket_price,c.remaining_tickets
FROM concerts AS c,artists AS a,scenes AS s,cities AS ci 
WHERE c.artist_id = a.artist_id AND c.scene_id = s.scene_id AND s.city_id= ci.city_id AND c.cancelled = false AND c.date>current_date AND c.time > current_time;";
$stmt = $conn->prepare($sql);
$stmt->execute();
$concerts = array();
$i=0;
while($row = $stmt->fetch(PDO::FETCH_ASSOC)){
    $concerts[$i] = new concert($row['concert_id'],$row['artist_name'],$row['scene_name'],$row['address'],$row['city'],$row['date'],$row['time'],$row['ticket_price'],$row['remaining_tickets']);
    $i++;
}
echo json_encode($concerts);
?>