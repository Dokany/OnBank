<?php
/******************************************
CSCE 253/2501
Summer 2018
Project 1

Mohamed T Abdelrahman (ID no. 900142457)
Yasmin ElDokany (ID no. 900131538)
******************************************/

// Required if your environment does not handle autoloading
require __DIR__ . '/../vendor/autoload.php';

use Twilio\Rest\Client;

class SmsController
{
    public function sendSms($body)
    {
        $sid = 'AC9766ba462cb35019030fd5a3c00c4896';
        $token = '0e158a1ee3110f37fa7e3d23f8f89483';
        $client = new Client($sid, $token);
        try
        {  
            // Use the client to do fun stuff like send text messages!
            $client->messages->create(
                // the number to send the message to
                '+XXXXXXXXXXXX',
                array(
                // Twilio phone number
                'from' => '+19316503551',
                // the body of the text
                'body' => $body
                )
            );
        }
        catch (Exception $e)
        {
            echo "Error: " . $e->getMessage();
        }
    }
}
?>