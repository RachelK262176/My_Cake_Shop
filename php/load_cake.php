<?php
error_reporting(0);
include_once("dbconnect.php");
//$location = $_POST['location'];
$sql = "SELECT * FROM CAKE"; 
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $response["cake"] = array();
    while ($row = $result ->fetch_assoc()){
        $cakelist = array();
        $cakelist[cakeid] = $row["CAKEID"];
        $cakelist[cakename] = $row["CAKENAME"];
        $cakelist[cakeprice] = $row["CAKEPRICE"];
        $cakelist[quantity] = $row["QUANTITY"];
        $cakelist[ingredients] = $row["INGREDIENTS"];
        $cakelist[step] = $row["STEP"];
        $cakelist[image] = $row["IMAGE"];
        $cakelist[rating] = $row["RATING"];
        array_push($response["cake"], $cakelist);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}
?>
