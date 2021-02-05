<?php
error_reporting(0);
include_once("dbconnect.php");

$email = $_POST['email'];
$commentid = $_POST['commentid'];

    $sqldelete = "DELETE FROM COMMENT WHERE EMAIL = '$email' AND COMMENTID ='$commentid'";
    if ($conn->query($sqldelete) === TRUE){
       echo "success";
    }else {
        echo "failed";
    }
?>