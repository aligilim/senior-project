<?php
require('connection.php');

$makeQuery = "SELECT * FROM patients ";

$statement = $connection->prepare($makeQuery);

$statement ->execute();

$myArray = array();

while ($resultsFrom = $statement->fetch()){

    array_push($myArray,array(
        "id"=>$resultsFrom['id'],
        "blood_type"=>$resultsFrom['blood_type'],
        "current_location"=>$resultsFrom['current_location'],
        "current_lati"=>$resultsFrom['current_lati'],
        "current_longi"=>$resultsFrom['current_longi'],
        "age"=>$resultsFrom['age'],
        "email"=>$resultsFrom['email'],
        "fullname"=>$resultsFrom['fullname'],
        "gender"=>$resultsFrom['gender'],
        "joinTime"=>$resultsFrom['joinTime'],
        "location"=>$resultsFrom['location'],
        "lati"=>$resultsFrom['lati'],
        "longi"=>$resultsFrom['longi'],
        "occupation"=>$resultsFrom['occupation'],
        "phone"=>$resultsFrom['phone'],
        "userType"=>$resultsFrom['userType'],
        "vaccinated"=>$resultsFrom['vaccinated'],
        "dateOfVaccination"=>$resultsFrom['dateOfVaccination'],
        "dose"=>$resultsFrom['dose'],
        "vaccineType"=>$resultsFrom['vaccineType'],
    ));
}

echo json_encode($myArray);
?>