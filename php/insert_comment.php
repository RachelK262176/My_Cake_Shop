<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$cakeid = $_POST['cakeid'];
$comment = $_POST['comment'];
$image = $_POST['image'];

//$sqlcheck = "SELECT * FROM COMMENT WHERE CAKEID = '$cakeid' AND EMAIL = '$email'";
//$result = $conn->query($sqlcheck);
//if ($result->num_rows > 0) {
//    $sqlupdate = "UPDATE CAKEORDER SET CAKEQTY = '$cakeqty',REMARK = '$remark' WHERE CAKEID = '$cakeid' AND EMAIL = '$email'";
//    if ($conn->query($sqlupdate) === TRUE){
//       echo "success";
//    }  
//}
//else{
    $sqlinsert = "INSERT INTO COMMENT(EMAIL,CAKEID,COMMENT,IMAGE) VALUES ('$email','$cakeid','$comment','$image')";
    if ($conn->query($sqlinsert) === TRUE){
       echo "success";
    }    
//}

?>