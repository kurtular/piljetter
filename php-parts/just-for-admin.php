<?php
if($_SESSION['userRole']!="admin"){
    http_response_code(404);
    exit();
}
?>