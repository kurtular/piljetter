<?php
session_start();
if(!isset($_SESSION['userId']) || !isset($_SESSION['userRole'])){
    header("location:login.php");
}
?>