<?php
session_start();
if(isset($_GET['signout'])){
    session_destroy();
    header("location:login.php");
}else if(isset($_SESSION['userId'])){
    header("location:index.php");
}else if(isset($_POST['submit'])){
$userName = $_POST['username'];
$password = $_POST['password'];
require 'php-parts/db-connection.php';
$sql= "SELECT u.user_id,r.role FROM users AS u,roles as r WHERE r.role_id=u.role_id AND user_name='$userName' AND password='$password'";
$stmt = $conn->prepare($sql);
$stmt->execute();
while($row = $stmt->fetch(PDO::FETCH_ASSOC)){
    $_SESSION['userId'] = $row['user_id'];
    $_SESSION['userRole'] = $row['role'];
    if($_SESSION['userRole']=="admin"){
        header("location:ad-index.php");
    }else{header("location:index.php");}
} 
if(!isset($_SESSION['userId'])){
$msg ="!! Felaktig användarnamn eller lösenord. !!";}
}
else if(isset($_POST['registrate'])){
    
    $customerRole = 'customer';
    $firstName = $_POST['firstname'];
    $lastName = $_POST['lastname'];
    $email = $_POST['email'];
    $userName = $_POST['username'];
    $password = $_POST['password'];
    $repeatPassword = $_POST['repeatpassword'];
    if ($password == $repeatPassword) {
    require 'php-parts/db-connection.php';
    $sql= "SELECT create_user('$userName', '$password', '$firstName', '$lastName', '$email', '$customerRole')  ";
    $stmt = $conn->prepare($sql);
    $stmt->execute();
    header("location:login.php");}
    else {
        $wrongpassreg = "wrong pass";
    }
}
    


?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link rel="shortcut icon" href="img/icon.png" type="image/x-icon">
    <link href="https://fonts.googleapis.com/css?family=Fugaz+One|Lato|Nova+Flat|Sofia&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/login.css">
    <title>Inloggning</title>
</head>
<body>
    <form  id="login_form" method="POST">
        <img src="img/logo.png">
        <input type="text" name="username" placeholder="Användarnamn" required autocomplete="off">
        <input type="password" name="password" placeholder="Lösenord" required autocomplete="off">
        <button name="submit" type="submit" value="login">Logga in</button>
        <?php
        if(isset($msg)){
            echo "<h5 id='msg'>".$msg."</h5>";
        }
        ?>
        <span onclick="show('reg')">Skapa ett konto</span>
    </form>
    <form id="reg_form" method="POST">
        <img src="img/logo.png">
        <div>
        <div>
            <label for="firstname"><b>Förnamn</b></label>
            <input type="text" name="firstname" required>
        </div>
        <div>
            <label for="lastname"><b>Efternamn</b></label>
            <input type="text" name="lastname"  required>
        </div>
        <div>
            <label for="email"><b>Email</b></label>
            <input type="email" name="email"  required>
        </div>
        <div>
            <label for="username"><b>Användarnamn</b></label>
            <input type="text" name="username"  required>
        </div>
        <div>
            <label for="password"><b>Lösenord</b></label>
            <input type="password" name="password"  required>
        </div>
        <div>
            <label for="repeatpassword"><b>Repetera lösenord</b></label>
            <input type="password" name="repeatpassword"  required>
        </div>
    </div>
<button name="registrate" type="submit" value="registrate">Registrera</button>
<span onclick='show("log")'>Logga in</span>
</form>
</body>
<script src="js/login.js"></script>
</html>