<?php
require('connection.php');

$id = $_POST["id"];
$one = $_POST["one"];
$two = $_POST["two"];
$three = $_POST["three"];
$four = $_POST["four"];
$five = $_POST["five"];
$six = $_POST["six"];
$seven = $_POST["seven"];
$eight = $_POST["eight"];
$nine = $_POST["nine"];
$ten = $_POST["ten"];
$eleven = $_POST["eleven"];
$twelve = $_POST["twelve"];
$thirteen = $_POST["thirteen"];
$fourteen = $_POST["fourteen"];

$queryst = "INSERT INTO symptoms (id,one,two,three,four,five,six,seven,eight,nine,ten,eleven,twelve,thirteen,fourteen) VALUES('".$id."','".$one."','".$two."','".$three."','".$four."','".$five."','".$six."','".$seven."','".$eight."','".$nine."','".$ten."','".$eleven."','".$twelve."','".$thirteen."','".$fourteen."') ON DUPLICATE KEY UPDATE one='".$one."', two='".$two."', three='".$three."', four='".$four."', five='".$five."', six='".$six."',seven='".$seven."',eight='".$eight."', nine='".$nine."',ten='".$ten."',eleven='".$eleven."',twelve='".$twelve."',thirteen='".$thirteen."',fourteen='".$fourteen."'";

$statement = $connection -> prepare($queryst);

$statement -> execute();

echo json_encode("Inserted Data !!!");


?>