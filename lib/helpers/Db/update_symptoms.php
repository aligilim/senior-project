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

$queryst = "UPDATE symptoms SET id = '".$id."', one='".$one."', two='".$two."', three='".$three."', four='".$four."', five='".$five."', six='".$six."',seven='".$seven."',eight='".$eight."', nine='".$nine."',ten='".$ten."',eleven='".$eleven."',twelve='".$twelve."',thirteen='".$thirteen."',fourteen='".$fourteen."' WHERE id = '".$id."'";

$statement = $connection -> prepare($queryst);

$statement -> execute();

echo json_encode("UPDATED");


?>