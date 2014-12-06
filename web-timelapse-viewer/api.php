<?php

// images must be on format <prefix>YYYYMMDD_HHMM.jpg
// videos must be on format YYYYMMDD.webm

$highreshourlypicturesfolder = "../hourlypictures/";
$highreshourlypicturesprefix = "1080i_";
$timelapsefolder = "../timelapses/";

if(isset($_GET['get']) && $_GET['get'] == "picture") {
    $date = $_GET['date'];
    $hour = $_GET['hour'];
    if(validate_date($date) and validate_hour($hour)) {
        $date = str_replace("-", "", $date);
        $file = $highreshourlypicturesfolder.$highreshourlypicturesprefix.$date."_".$hour.".jpg";
        if(file_exists($file)) {
            echo "<img class='img-responsive' alt='Responsive image' src='$file'/>";
        } else {
            echo "Finner ikke bildet. :/";
        }
    }
}
if(isset($_GET['get']) && $_GET['get'] == "video") {
    $date = $_GET['date'];
    if(validate_date($date)) {
        $file = $timelapsefolder.$date.".webm";
        if(file_exists($file)) {
            echo "<video src='$file'>";
        } else {
            echo "Finner ikke video fra valgt dato";
        }
    }
}



function validate_date($date) {
    if (preg_match("/^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/",$date))
    {
        return true;
    }else{
        return false;
    }
}
function validate_hour($hour) {
    if (preg_match("/^(0[1-9]|1[0-9]|2[0-3])00$/",$hour))
    {
        return true;
    }else{
        return false;
    }
}



?>

