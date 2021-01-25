<?php
// Import PHPMailer classes into the global namespace
// These must be at the top of your script, not inside a function
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;

// Load Composer's autoloader
require 'src/Exception.php';
require 'src/PHPMailer.php';
require 'src/SMTP.php';

// Instantiation and passing `true` enables exceptions
$mail = new PHPMailer(true);

include_once("dbconnect.php");
$name = $_POST['name'];
$phone = $_POST['phone'];
$email = $_POST['email'];
$password = sha1($_POST['password']);
$otp = rand(1000,9999);


//try {
    //Server settings
    $mail->SMTPDebug = 3;                      // Enable verbose debug output
    $mail->isMail();                                            // Send using SMTP
    $mail->Host       = 'mail.rachelcake.com';                    // Set the SMTP server to send through
    $mail->SMTPAuth   = true;                                   // Enable SMTP authentication
    $mail->Username   = 'mycakeshop@rachelcake.com';                     // SMTP username
    $mail->Password   = 'abc12345678900****';                               // SMTP password
    $mail->SMTPSecure = 'SSL';         // Enable TLS encryption; `PHPMailer::ENCRYPTION_SMTPS` encouraged
    $mail->Port       = 465;                                    // TCP port to connect to, use 465 for `PHPMailer::ENCRYPTION_SMTPS` above

$sqlregister = "INSERT INTO USER(NAME,PHONE,EMAIL,PASSWORD,DATEREG,OTP) VALUES('$name','$phone','$email','$password',now(),'$otp')";

if ($conn->query($sqlregister) === TRUE){
    echo "success";
    $mail->setFrom('mycakeshop@rachelcake.com', 'Sender');
    $mail->addAddress($email, 'Receiver');     // Add a recipient
    $mail->isHTML(true);                                  // Set email format to HTML
    $mail->Subject = 'From My Cake Shop. Verify your account';
    $mail->Body    = 'Hello '.$name.',<br/><br/>Thank you for register with us,'.' Please use the following link to verify your account : <br/><br/>http://rachelcake.com/mycakeshop/php/verify_account.php?email='.$email.'&key='.$otp;
    $mail->AltBody = 'This is the body in plain text for non-HTML mail clients';
    $mail->send();
}else{
    echo "failed";
}
    
//    echo 'Message has been sent';
//} catch (Exception $e) {
//    echo "Message could not be sent. Mailer Error: {$mail->ErrorInfo}";
//}