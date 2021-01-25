<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$cakeid = $_POST['cakeid'];
$cakeqty = $_POST['cakeqty'];
$remark = $_POST['remark'];

$sqlcheck = "SELECT * FROM CAKEORDER WHERE CAKEID = '$cakeid' AND EMAIL = '$email'";
$result = $conn->query($sqlcheck);
if ($result->num_rows > 0) {
    $sqlupdate = "UPDATE CAKEORDER SET CAKEQTY = '$cakeqty',REMARK = '$remark' WHERE CAKEID = '$cakeid' AND EMAIL = '$email'";
    if ($conn->query($sqlupdate) === TRUE){
       echo "success";
    }  
}
else{
    $sqlinsert = "INSERT INTO CAKEORDER(EMAIL,CAKEID,CAKEQTY,REMARK) VALUES ('$email','$cakeid','$cakeqty','$remark')";
    if ($conn->query($sqlinsert) === TRUE){
       echo "success";
    }    
}

?>