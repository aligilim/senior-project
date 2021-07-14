<?php
require('connection.php');

$makeQuery = "SELECT * FROM symptoms ";

$statement = $connection->prepare($makeQuery);

$statement ->execute();

$myArray = array();

while ($resultsFrom = $statement->fetch()){

    array_push($myArray,array(
        "id"=>$resultsFrom['id'],
        "one"=>$resultsFrom['one'],
        "two"=>$resultsFrom['two'],
        "three"=>$resultsFrom['three'],
        "four"=>$resultsFrom['four'],
        "five"=>$resultsFrom['five'],
        "six"=>$resultsFrom['six'],
        "seven"=>$resultsFrom['seven'],
        "eight"=>$resultsFrom['eight'],
        "nine"=>$resultsFrom['nine'],
        "ten"=>$resultsFrom['ten'],
        "eleven"=>$resultsFrom['eleven'],
        "twelve"=>$resultsFrom['twelve'],
        "thirteen"=>$resultsFrom['thirteen'],
        "fourteen"=>$resultsFrom['fourteen'],
    ));
}

echo json_encode($myArray);
?>