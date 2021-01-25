<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];

$sql = "SELECT COMMENT.CAKEID, COMMENT.COMMENT, COMMENT.IMAGE, CAKE.CAKENAME, CAKE.IMAGE, CAKE.CAKEPRICE FROM COMMENT 
INNER JOIN CAKE ON COMMENT.CAKEID = CAKE.CAKEID 
WHERE COMMENT.EMAIL = '$email'";


$result = $conn->query($sql);
if ($result->num_rows > 0) {
    $response["cmd"] = array();
    while ($row = $result ->fetch_assoc()){
        $cmdlist = array();
        $cmdlist[cakeid] = $row["CAKEID"];
        $cmdlist[comment] = $row["COMMENT"];
        $cmdlist[image] = $row["IMAGE"];
        $cmdlist[cakename] = $row["CAKENAME"];
        $cmdlist[image] = $row["IMAGE"];
        $cmdlist[cakeprice] = $row["CAKEPRICE"];
        array_push($response["cmd"], $cmdlist);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}
?>