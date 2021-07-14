<?php
try {
$connection = new PDO('mysql:host=localhost','dbname=id17239629_covidserver','id17239629_coviduser','[Ru[A)=e!Va*98x^');
$connection -> setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

} catch (PDOException $exc){
echo $exc -> getMessage();
die("not connected");
}
?>