<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$sql = "SELECT * FROM COMMENT WHERE COMMENT.EMAIL = '$email'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $response["cmd"] = array();
    while ($row = $result ->fetch_assoc()){
        $cmdlist = array();
        //$cmdlist[email] = $row["EMAIL"];
        $cmdlist[cakename] = $row["CAKENAME"];
        $cmdlist[name] = $row["NAME"];
        $cmdlist[comment] = $row["COMMENT"];
        $cmdlist[image] = $row["IMAGE"];
        array_push($response["cmd"], $cmdlist);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}
?>