<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];

$sql = "SELECT CAKEORDER.CAKEID, CAKEORDER.CAKEQTY, CAKEORDER.REMARK, CAKE.CAKENAME, CAKE.IMAGE, CAKE.CAKEPRICE, CAKE.QUANTITY FROM CAKEORDER 
INNER JOIN CAKE ON CAKEORDER.CAKEID = CAKE.CAKEID 
WHERE CAKEORDER.EMAIL = '$email'";


$result = $conn->query($sql);
if ($result->num_rows > 0) {
    $response["cart"] = array();
    while ($row = $result ->fetch_assoc()){
        $cartlist = array();
        $cartlist[cakeid] = $row["CAKEID"];
        $cartlist[cakeqty] = $row["CAKEQTY"];
        $cartlist[remark] = $row["REMARK"];
        $cartlist[cakename] = $row["CAKENAME"];
        $cartlist[image] = $row["IMAGE"];
        $cartlist[cakeprice] = $row["CAKEPRICE"];
        $cartlist[quantity] = $row["QUANTITY"];
        array_push($response["cart"], $cartlist);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}
?>