<?php
header("Content-type: application/json; charset=utf-8");
require '../php-parts/login-check.php';
require '../php-parts/db-connection.php';
require '../php-parts/obj.php';
require '../php-parts/just-for-admin.php';
// recive data
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
//create page
if(isset($_POST["addConcert"]) && isset($_POST["artId"])&& $_POST["artId"]!="" && isset($_POST["sceId"]) && $_POST["sceId"]!="" && isset($_POST["remTic"]) && $_POST["remTic"]!="" && isset($_POST["date"]) && $_POST["date"]!="" && isset($_POST["time"]) && $_POST["time"]!=""){
    $sql= "INSERT INTO concerts (artist_id,scene_id,date,time,remaining_tickets) VALUES ('$_POST[artId]','$_POST[sceId]','$_POST[date]','$_POST[time]','$_POST[remTic]')";
    $stmt = $conn->prepare($sql);
    try{
        $stmt->execute();
        echo '{"msg":"Det gick bra att addera konserten."}';
    }catch(Exception $e){
        if(strpos($stmt->errorInfo()[2],"concerts_date_artist_id_unique")){
            echo '{"msg":"Artisten har redan en konsert att fyra på samma dag."}';
        }else if(strpos($stmt->errorInfo()[2],"concerts_date_scene_id_unique")){
            echo '{"msg":"Scenen är bokad på samma dag."}';
        }else
        echo '{"msg":"Det gick inte att addera konserten.'.$stmt->errorInfo()[2].'"}';
    }
    exit();
}
if(isset($_POST["addArtist"]) && isset($_POST["name"])&& $_POST["name"]!="" && isset($_POST["pop"]) && $_POST["pop"]!=""){
    $sql= "INSERT INTO artists (name,popularity) VALUES ('$_POST[name]','$_POST[pop]')";
    $stmt = $conn->prepare($sql);
    try{
        $stmt->execute();
        echo '{"msg":"Det gick bra att addera artisten: '.$_POST["name"].'"}';
    }catch(Exception $e){
        echo '{"msg":"Det gick inte att addera artisten."}';
    }
    exit();
}
if(isset($_POST["addScene"]) && isset($_POST["name"])&& $_POST["name"]!="" && isset($_POST["rate"]) && $_POST["rate"]!=""&& isset($_POST["cap"]) && $_POST["cap"]!=""&& isset($_POST["address"]) && $_POST["address"]!=""&& isset($_POST["zip"]) && $_POST["zip"]!=""&& isset($_POST["cityId"]) && $_POST["cityId"]!=""){
    $sql= "INSERT INTO scenes (name,rate,capacity,address,zip_code,city_id) VALUES ('$_POST[name]','$_POST[rate]','$_POST[cap]','$_POST[address]','$_POST[zip]','$_POST[cityId]')";
    $stmt = $conn->prepare($sql);
    try{
        $stmt->execute();
        echo '{"msg":"Det gick bra att addera scenen: '.$_POST["name"].'"}';
    }catch(Exception $e){
        if($e->getCode()==23505){
            echo '{"msg":"Denna scenen finns redan."}';
        }else if($e->getCode()==23514){
            echo '{"msg":"Capacitet ska vara positiv och större än 0."}';
        }else
        echo '{"msg":"Det gick inte att addera scenen."}';
    }
    exit();
}
if(isset($_POST["addCity"]) && isset($_POST["city"])&& $_POST["city"]!="" && isset($_POST["country"]) && $_POST["country"]!=""){
    $sql= "INSERT INTO cities (city,country) VALUES ('$_POST[city]','$_POST[country]')";
    $stmt = $conn->prepare($sql);
    try{
        $stmt->execute();
        echo '{"msg":"Det gick bra att addera staden: '.$_POST["city"].'"}';
    }catch(Exception $e){
        echo '{"msg":"Det gick inte att addera staden."}';
    }
    exit();
}
if(isset($_POST["createAdmin"]) && isset($_POST["fname"])&& $_POST["fname"]!="" && isset($_POST["lname"]) && $_POST["lname"]!="" && isset($_POST["email"]) && $_POST["email"]!="" && isset($_POST["uname"]) && $_POST["uname"]!=""  && isset($_POST["psw"]) && $_POST["psw"]!=""){
    $sql= "SELECT create_user('$_POST[uname]','$_POST[psw]','$_POST[fname]','$_POST[lname]','$_POST[email]','admin')";
    $stmt = $conn->prepare($sql);
    try{
        $stmt->execute();
        echo '{"msg":"Det gick bra att addera kontot: '.$_POST["uname"].'"}';
    }catch(Exception $e){
        if(strpos($stmt->errorInfo()[2],"users_user_name_key")){
            echo '{"msg":"Konton finns redan."}';
        }else
        echo '{"msg":"Det gick inte att addera kontot."}';
    }
    exit();
}

//show data
//statistic sub page
if(isset($_POST["updateSta"]) && isset($_POST["fSold"]) && isset($_POST["fSold"])&& isset($_POST["tSold"]) && isset($_POST["tSold"])&& isset($_POST["fBest"]) && isset($_POST["fBest"])&& isset($_POST["tBest"]) && isset($_POST["tBest"])&& isset($_POST["fActive"]) && isset($_POST["fActive"])&& isset($_POST["tActive"]) && isset($_POST["tActive"])){
    $sql="SELECT * FROM total_income_tickets_amount WHERE date >= '$_POST[fSold]' AND date <= '$_POST[tSold]'";
    $stmt = $conn->prepare($sql);
    $stmt->execute();
    $date=[];
    $income=[];
    $tickets=[];
    $i=0;
    while($row = $stmt->fetch(PDO::FETCH_ASSOC)){
        $date[$i] = $row['date'];
        $income[$i] = $row['total_income'];
        $tickets[$i] = $row['amount_sold_tickets'];
        $i++; 
    }
    $soldsta = new SoldSta($date,$income,$tickets);
    
    /**/
    $sql="SELECT CONCAT_WS(' ','#',artist_id,artist_name)AS artist,tickets_sold FROM best_selling_artists('$_POST[fBest]','$_POST[tBest]')";
    $stmt = $conn->prepare($sql);
    $stmt->execute();
    $artists=[];
    $sold=[];
    $i=0;
    while($row = $stmt->fetch(PDO::FETCH_ASSOC)){
        $artists[$i] = $row['artist']." ";
        $sold[$i] = $row['tickets_sold'];
        $i++; 
    }
    $beststa = new BestSta($artists,$sold);

    /**/
    $sql="SELECT * FROM public.unused_vouchers_statistic WHERE expire_month >= '$_POST[fActive]' AND expire_month <= '$_POST[tActive]'";
    $stmt = $conn->prepare($sql);
    $stmt->execute();
    $months=[];
    $amountVouchers=[];
    $i=0;
    while($row = $stmt->fetch(PDO::FETCH_ASSOC)){
        $months[$i] = $row['expire_month'];
        $amountVouchers[$i] = $row['amount_vouchers'];
        $i++; 
    }
    $activesta = new ActiveSta($months,$amountVouchers);

    /* */
    echo '{"soldSta":';
    echo json_encode($soldsta,JSON_PRETTY_PRINT);
    echo ',"bestSta":';
    echo json_encode($beststa,JSON_PRETTY_PRINT);
    echo ',"activeSta":';
    echo json_encode($activesta,JSON_PRETTY_PRINT);
    echo '}';
    exit();
}
//concert overview
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
//create page select options
if(isset($_POST["createPg"])){
$sql="SELECT artist_id,CONCAT_WS(' ','id:',artist_id,'namn:',name,'popularitet:',popularity) AS value FROM artists ORDER BY name";
$stmt = $conn->prepare($sql);
$stmt->execute();
$artistsL=[];
$i=0;
while($row = $stmt->fetch(PDO::FETCH_ASSOC)){
    $artistsL[$i] = new Option($row['artist_id'],$row['value']);
    $i++; 
}
$sql="SELECT city_id,CONCAT_WS(' ','id:',city_id,'city:',city,'country:',country) AS value FROM cities ORDER BY city";
$stmt = $conn->prepare($sql);
$stmt->execute();
$citiesL=[];
$i=0;
while($row = $stmt->fetch(PDO::FETCH_ASSOC)){
    $citiesL[$i] = new Option($row['city_id'],$row['value']);
    $i++; 
}

$sql="SELECT scene_id,CONCAT_WS(' ','id:',s.scene_id,'namn:',s.name,'renommé:',s.rate,'capcitet:',s.capacity,'adress:',s.address,s.zip_code,(Select CONCAT_WS(' ','(',ci.city,ci.country,')') FROM cities AS ci WHere ci.city_id=s.city_id)) AS value FROM Scenes AS s ORDER BY s.name";
$stmt = $conn->prepare($sql);
$stmt->execute();
$scenesL=[];
$i=0;
while($row = $stmt->fetch(PDO::FETCH_ASSOC)){
    $scenesL[$i] = new Option($row['scene_id'],$row['value']);
    $i++; 
}

echo '{"artistsL":';
echo json_encode($artistsL,JSON_PRETTY_PRINT);
echo ',"citiesL":';
echo json_encode($citiesL,JSON_PRETTY_PRINT);
echo ',"scenesL":';
echo json_encode($scenesL,JSON_PRETTY_PRINT);
echo '}';
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