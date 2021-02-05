<?php
include_once("dbconnect.php");
$cakename = $_POST['cakename'];
$cakeprice = $_POST['cakeprice'];
$quantity = $_POST['quantity'];
$ingredients = $_POST['ingredients'];
$step = $_POST['step'];
$image = $_POST['image'];
$rating = $_POST['rating'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);
$path = '../images/cakeimages/'.$image.'.jpg';
$is_written = file_put_contents($path, $decoded_string);

if ($is_written > 0) {
    $sqlregister = "INSERT INTO CAKE(CAKENAME,CAKEPRICE,QUANTITY,INGREDIENTS,STEP,IMAGE,RATING) VALUES('$cakename','$cakeprice','$quantity','$ingredients','$step','$image','$rating')";
    if ($conn->query($sqlregister) === TRUE){
        echo "success";
    }else{
        echo "failed";
    }
}else{
    echo "failed";
}

?>