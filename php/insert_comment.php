<?php
error_reporting(0);
include_once("dbconnect.php");
//$commentid = $_POST['commentid'];
$email = $_POST['email'];
$cakename = $_POST['cakename'];
$name = $_POST['name'];
$comment = $_POST['comment'];
$image = $_POST['image'];
//$commentdate = $_POST['commentdate'];

$sqlinsert = "INSERT INTO COMMENT(EMAIL,CAKENAME,NAME,COMMENT,IMAGE) VALUES ('$email','$cakename','$name','$comment','$image')";
    if ($conn->query($sqlinsert) === TRUE){
       echo "success";
    } else {
    echo "failed";
}    

?>