<?php
error_reporting(0);
include_once("dbconnect.php");
$commentid = $_POST['commentid'];
$email = $_POST['email'];
$name = $_POST['name'];
$smallcmt = $_POST['smallcmt'];
//$smallcmtdate = $_POST['smallcmtdate'];

$sqlinsert = "INSERT INTO SMALLCOMMENT(COMMENTID,EMAIL,NAME,SMALLCMT) VALUES ('$commentid','$email','$name','$smallcmt')";
    if ($conn->query($sqlinsert) === TRUE){
       echo "success";
    } else {
    echo "failed";
}    

?>