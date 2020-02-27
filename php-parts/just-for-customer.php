<?php
if($_SESSION['userRole']!="customer"){
    http_response_code(404);
    exit();
}
?>