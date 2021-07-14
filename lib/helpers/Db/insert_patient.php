<?php
require('connection.php');
$id=$_POST['id'];
$blood_type=$_POST['blood_type'];
$current_location=$_POST['current_location'];
$current_lati=$_POST['current_lati'];
$current_longi=$_POST['current_longi'];
$age=$_POST['age'];
$email=$_POST['email'];
$fullname=$_POST['fullname'];
$gender=$_POST['gender'];
$joinTime=$_POST['joinTime'];
$location=$_POST['location'];
$lati=$_POST['lati'];
$longi=$_POST['longi'];
$occupation=$_POST['occupation'];
$phone=$_POST['phone'];
$userType=$_POST['userType'];
$vaccinated=$_POST['vaccinated'];
$dateOfVaccination=$_POST['dateOfVaccination'];
$dose=$_POST['dose'];
$vaccineType=$_POST['vaccineType'];


$queryst = "INSERT INTO symptoms (id,,,,current_longi,age,email,fullname,gender,joinTime,home_location,lati,longi,occupation,phone,userType,vaccinated,dateOfVaccination,dose,vaccineType) VALUES('".$id."','".$blood_type."','".$current_location."','".$current_lati."','".$current_longi."','".$age."','".$email."','".$fullname."','".$gender."','".$joinTime."','".$location."','".$lati."','".$longi."','".$occupation."','".$phone."','".$userType."','".$vaccinated."','".$dateOfVaccination."','".$dose."','".$vaccineType."') ON DUPLICATE KEY UPDATE email='".$email."',blood_type='".$blood_type."',current_location='".$current_location."',current_lati='".$current_lati."',current_longi='".$current_longi."',age='".$age."',fullname='".$fullname."',gender='".$gender."',joinTime='".$joinTime."',location='".$location."',lati='".$lati."',longi='".$longi."',occupation='".$occupation."',phone='".$phone."',userType='".$userType."',vaccinated='".$vaccinated."',dateOfVaccination='".$dateOfVaccination."',dose='".$dose."',vaccineType='".$vaccineType."'";

$statement = $connection -> prepare($queryst);

$statement -> execute();

echo json_encode("Inserted Patient !!!");


?>