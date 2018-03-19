<?php
$servername = "localhost";
$username = "id4769414_prco304";
$password = "memes";
$database = "id4769414_nursery";

    //create connection
    $con = mysqli_connect($servername, $username, $password, $database);
    
    //check connection
    if (mysqli_connect_errno())
    {
        echo "Failed to connect to MySQL: " . mysqli_connect_error();
    }
    
    //select all from staff
    $sql = "SELECT * FROM Staff";
    
    //check there are results
    if ($result = mysqli_query($con, $sql))
    {
        //if so, create results array and temp array to hold data
        $resultArray = array();
        $tempArray = array();
        
        //loop through each row in the result set
        while($row = $result->fetch_object())
        {
            $tempArray = $row;
            array_push($resultArray, $tempArray);
        }
        
        //finally encode the array to json and output the results
        echo json_encode($resultArray);
    }
    //close connection
    mysqli_close($con);    
?>
