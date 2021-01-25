<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$cakeid = $_POST['cakeid'];
    $sqldelete = "DELETE FROM CAKEORDER WHERE EMAIL = '$email' AND CAKEID='$cakeid'";
    if ($conn->query($sqldelete) === TRUE){
       echo "success";
    }else {
        echo "failed";
    }
?>