<?php
error_reporting(0);
include_once("dbconnect.php");

$commentid = $_POST['commentid'];

$sql = "SELECT * FROM SMALLCOMMENT WHERE COMMENTID = '$commentid'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $response["smallcmt"] = array();
    while ($row = $result ->fetch_assoc()){
        $smallcmtlist = array();
        $smallcmtlist[commentid] = $row["COMMENTID"];
        $smallcmtlist[email] = $row["EMAIL"];
        $smallcmtlist[name] = $row["NAME"];
        $smallcmtlist[smallcmt] = $row["SMALLCMT"];
        $smallcmtlist[smallcmtdate] = $row["SMALLCMTDATE"];
        
        array_push($response["smallcmt"], $smallcmtlist);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}
?>