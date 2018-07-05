<?php
/******************************************
CSCE 253/2501
Summer 2018
Project 1

Mohamed T Abdelrahman (ID no. 900142457)
Yasmin ElDokany (ID no. 900131538)
******************************************/


use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;

require '../vendor/autoload.php';
require_once '../includes/DbOperation.php';

//Creating a new app with the config to show errors
$app = new \Slim\App([
    'settings' => [
        'displayErrorDetails' => true
    ]
]);

// Logging in any registered user
$app->post('/login', function (Request $request, Response $response) {
$json = $request->getBody();
    $requestData = json_decode($json, true);
    $username = $requestData['username'];
    $password = $requestData['password'];

    if(isset($username) && isset($password)) {
        $db = new DbOperation();

        $responseData = array();

        $resultAdmin = $db->adminLogin($username, $password);
        $resultTeller = $db->tellerLogin($username, $password);
        $resultClient = $db->clientLogin($username, $password);

        if ($resultAdmin == 0) {
            $responseData['type'] = 'admin';
            $responseData['change'] = 0;
            $responseData['id'] = $db->adminID($username);
        } elseif ($resultTeller == 0) {
            $responseData['type'] = 'teller';
            $responseData['change'] = 0;
            $responseData['id'] = $db->tellerID($username);
        } elseif ($resultTeller == 1) {
            $responseData['type'] = 'teller';
            $responseData['change'] = 1;
            $responseData['id'] = $db->tellerID($username);
        } elseif ($resultClient == 0) {
            $responseData['type'] = 'client';
            $responseData['change'] = 0;
            $responseData['id'] = $db->clientID($username);
        } elseif ($resultClient == 1) {
            $responseData['type'] = 'client';
            $responseData['change'] = 1;
            $responseData['id'] = $db->clientID($username);
        } else {
            $responseData['type'] = 'unknown';
            $responseData['change'] = 0;
            $responseData['id'] = NULL;
        }
        $response->getBody()->write(json_encode($responseData));
    } else {
        $responseData = array();
        $responseData["type"] = 'unknown';
        $responseData["message"] = 'Required field(s) missing!';
        $response->getBody()->write(json_encode($responseData));
    }
});

/********************************
* Administrator Functionalities *
*********************************/
// Creating a new admin
$app->post('/adminCreate', function (Request $request, Response $response) {
    $json = $request->getBody();
    $requestData = json_decode($json, true);
    $username = $requestData['username'];
    $password = $requestData['password'];

    if(isset($username) && isset($password)) {
         $db = new DbOperation();
        $responseData = array();

        $result = $db->createAdmin($username, $password);

        if ($result == 0) {
            $responseData['success'] = 1;
        } elseif ($result == 1) {
            $responseData['success'] = 0;
        } elseif ($result == 2) {
            //$responseData['message'] = 'Admin Username Taken!';
            $responseData['success'] = 0;
        }

        $response->getBody()->write(json_encode($responseData));
    }  else {
        $responseData = array();
        $responseData["type"] = 'error';
        $responseData["message"] = 'Required field(s) missing!';
        $response->getBody()->write(json_encode($responseData));
    }
});

// Admin login route
$app->post('/adminLogin', function (Request $request, Response $response) {
$json = $request->getBody();
    $requestData = json_decode($json, true);
    $username = $requestData['username'];
    $password = $requestData['password'];

    if(isset($username) && isset($password)) {
        $db = new DbOperation();

        $responseData = array();

        $result = $db->adminLogin($username, $password);

        if ($result == 0) {
            $responseData['type'] = 'admin';
            $responseData['change'] = 0;
            $responseData['id'] = $db->adminID($username);
        } elseif ($result == 1) {
            $responseData['type'] = 'unknown';
            $responseData['change'] = 0;
            $responseData['id'] = NULL;
        } else {
            $responseData['type'] = 'unknown';
            $responseData['change'] = 0;
            $responseData['id'] = NULL;
        }
        $response->getBody()->write(json_encode($responseData));
    } else {
        $responseData = array();
        $responseData["type"] = 'unknown';
        $responseData["message"] = 'Required field(s) missing!';
        $response->getBody()->write(json_encode($responseData));
    }
});

// Getting list of all admins
$app->post('/getAdmins', function (Request $request, Response $response) {
    $json = $request->getBody();
    $requestData = json_decode($json, true);
    $db = new DbOperation();
    $transactions = $db->getAdmins();
    $response->getBody()->write(json_encode($transactions));
});

// Deleting admin
$app->post('/adminDelete', function (Request $request, Response $response) {
    $json = $request->getBody();
    $requestData = json_decode($json, true);
    $username = $requestData['username'];

    if(isset($username)) {
        $db = new DbOperation();

        $responseData = array();

        $result = $db->adminDelete($username);

        if ($result == 0) {
            $responseData['success'] = 1;
        } elseif ($result == 1) {
            //$responseData['message'] = 'An Error Occured!';
            $responseData['success'] = 0;
        } else {
            //$responseData['message'] = 'Invalid Admin Username!';
            $responseData['success'] = 0;
        }

        $response->getBody()->write(json_encode($responseData));
    } else {
        $responseData = array();
        $responseData["type"] = 'error';
        $responseData["message"] = 'Required field(s) missing!';
        $response->getBody()->write(json_encode($responseData));
    }
});

// Changing admin password
$app->post('/changeAdminPass', function (Request $request, Response $response) {
    $json = $request->getBody();
    $requestData = json_decode($json, true);
    $username = $requestData['username'];
    $password = $requestData['password'];

    if(isset($username) && isset($password)) {
        $db = new DbOperation();

        $responseData = array();

        $result = $db->changeAdminPass($username, $password);

        if ($result == 0) {
            //$responseData['message'] = 'Admin Password Changed!';
            $responseData['success'] = 1;
        } elseif ($result == 1) {
            //$responseData['message'] = 'An Error Occured!!';
            $responseData['success'] = 0;
        } else {
            //$responseData['message'] = 'Invalid Admin Username!';
            $responseData['success'] = 0;
        }

        $response->getBody()->write(json_encode($responseData));
    } else {
        $responseData = array();
        $responseData["type"] = 'error';
        $responseData["message"] = 'Required field(s) missing!';
        $response->getBody()->write(json_encode($responseData));
    }
});

// Getting list of all transactions
$app->post('/allTransactions', function (Request $request, Response $response) {
    $json = $request->getBody();
    $requestData = json_decode($json, true);
    $db = new DbOperation();
    $transactions = $db->getAllTransactions();
    $response->getBody()->write(json_encode($transactions));
});

// Getting list of pending client applications
$app->post('/pendingClients', function (Request $request, Response $response) {
    $json = $request->getBody();
    $requestData = json_decode($json, true);
    $db = new DbOperation();
    $clients = $db->pendingClients();
    $response->getBody()->write(json_encode($clients));
});

// Viewing specific pending client application
$app->post('/viewPending', function (Request $request, Response $response) {
    $json = $request->getBody();
    $requestData = json_decode($json, true);
    $NIN = $requestData['NIN'];
    if(isset($NIN)) {
        $db = new DbOperation();
        $responseData = array();
        $client = $db->viewPending($NIN);
        $response->getBody()->write(json_encode($client));
    } else {
        $responseData = array();
        $responseData["type"] = 'unknown';
        $responseData["message"] = 'Required field(s) missing!';
        $response->getBody()->write(json_encode($responseData));
    }
});


// Viewing specific account owner info
$app->post('/viewOwner', function (Request $request, Response $response) {
    $json = $request->getBody();
    $requestData = json_decode($json, true);
    $NIN = $requestData['NIN'];
    if(isset($NIN)) {
        $db = new DbOperation();
        $responseData = array();
        $client = $db->viewOwner($NIN);
        $response->getBody()->write(json_encode($client));
    } else {
        $responseData = array();
        $responseData["type"] = 'unknown';
        $responseData["message"] = 'Required field(s) missing!';
        $response->getBody()->write(json_encode($responseData));
    }
});

// Approving client application account
$app->post('/approvePending', function (Request $request, Response $response) {
    $json = $request->getBody();
    $requestData = json_decode($json, true);
    $NIN = $requestData['NIN'];
    $AdminID = $requestData['adminId'];
    if(isset($NIN) && isset($AdminID)) {
        $db = new DbOperation();
        $responseData = array();
        $result = $db->approvePending($AdminID, $NIN);
        if ($result == 0) {
            $responseData['success'] = 1;
        } else {
            $responseData['success'] = 0;
        }
        $response->getBody()->write(json_encode($responseData));
    } else {
        $responseData = array();
        $responseData["type"] = 'unknown';
        $responseData["message"] = 'Required field(s) missing!';
        $response->getBody()->write(json_encode($responseData));
    }
});

/*************************
* Teller Functionalities *
*************************/
// Creating a new teller
$app->post('/tellerCreate', function (Request $request, Response $response) {
    $json = $request->getBody();
    $requestData = json_decode($json, true);
    $username = $requestData['username'];
    $password = $requestData['password'];

    if(isset($username) && isset($password)) {
         $db = new DbOperation();
        $responseData = array();

        $result = $db->createTeller($username, $password);

        if ($result == 0) {
            $responseData['success'] = 1;
        } elseif ($result == 1) {
            $responseData['success'] = 0;
        } elseif ($result == 2) {
            //$responseData['message'] = 'Admin Username Taken!';
            $responseData['success'] = 0;
        }

        $response->getBody()->write(json_encode($responseData));
    }  else {
        $responseData = array();
        $responseData["type"] = 'error';
        $responseData["message"] = 'Required field(s) missing!';
        $response->getBody()->write(json_encode($responseData));
    }
});

// Teller login route
$app->post('/tellerLogin', function (Request $request, Response $response) {
    $json = $request->getBody();
    $requestData = json_decode($json, true);
    $username = $requestData['username'];
    $password = $requestData['password'];

    if(isset($username) && isset($password)) {
        $db = new DbOperation();

        $responseData = array();

        $result = $db->tellerLogin($username, $password);

        if ($result == 0) {
            $responseData['type'] = 'teller';
            $responseData['change'] = 0;
            $responseData['id'] = $db->tellerID($username);
        } elseif ($result == 1) {
            $responseData['type'] = 'teller';
            $responseData['change'] = 1;
            $responseData['id'] = $db->tellerID($username);
        } elseif ($result == 2) {
            $responseData['type'] = 'unknown';
            $responseData['change'] = 0;
            $responseData['id'] = NULL;
        } else {
            $responseData['type'] = 'unknown';
            $responseData['change'] = 0;
            $responseData['id'] = NULL;
        }
        $response->getBody()->write(json_encode($responseData));
    } else {
        $responseData = array();
        $responseData["type"] = 'unknown';
        $responseData["message"] = 'Required field(s) missing!';
        $response->getBody()->write(json_encode($responseData));
    }
});

// Getting list of all tellers
$app->post('/getTellers', function (Request $request, Response $response) {
    $json = $request->getBody();
    $requestData = json_decode($json, true);
    $db = new DbOperation();
    $transactions = $db->getTellers();
    $response->getBody()->write(json_encode($transactions));
});

// Deleting teller
$app->post('/tellerDelete', function (Request $request, Response $response) {
    $json = $request->getBody();
    $requestData = json_decode($json, true);
    $username = $requestData['username'];

    if(isset($username)) {
        $db = new DbOperation();

        $responseData = array();

        $result = $db->tellerDelete($username);

        if ($result == 0) {
            $responseData['success'] = 1;
        } elseif ($result == 1) {
            //$responseData['message'] = 'An Error Occured!';
            $responseData['success'] = 0;
        } else {
            //$responseData['message'] = 'Invalid Teller Username!';
            $responseData['success'] = 0;
        }

        $response->getBody()->write(json_encode($responseData));
    } else {
        $responseData = array();
        $responseData["type"] = 'error';
        $responseData["message"] = 'Required field(s) missing!';
        $response->getBody()->write(json_encode($responseData));
    }
});

// Changing teller password
$app->post('/changeTellerPass', function (Request $request, Response $response) {
    $json = $request->getBody();
    $requestData = json_decode($json, true);
    $username = $requestData['username'];
    $password = $requestData['password'];

    if(isset($username) && isset($password)) {
        $db = new DbOperation();

        $responseData = array();

        $result = $db->changeTellerPass($username, $password);

        if ($result == 0) {
            //$responseData['message'] = 'Teller Password Changed!';
            $responseData['success'] = 1;
        } elseif ($result == 1) {
            //$responseData['message'] = 'An Error Occured!!';
            $responseData['success'] = 0;
        } else {
            //$responseData['message'] = 'Invalid Teller Username!';
            $responseData['success'] = 0;
        }

        $response->getBody()->write(json_encode($responseData));
    } else {
        $responseData = array();
        $responseData["type"] = 'error';
        $responseData["message"] = 'Required field(s) missing!';
        $response->getBody()->write(json_encode($responseData));
    }
});

/*************************
* Client Functionalities *
*************************/
// For teller to create a new client
$app->post('/clientCreate', function (Request $request, Response $response) {
    $json = $request->getBody();
    $requestData = json_decode($json, true);
    $CUsername = $requestData['username'];
    $pass = $requestData['password'];
    $Fname = $requestData['fname'];
    $Lname = $requestData['lname'];
    $NIN = $requestData['NIN'];
    $Address = $requestData['address'];
    $PhoneNo = $requestData['phone'];
    $Email = $requestData['email'];
    $TellerID = $requestData['id'];
    if(isset($CUsername) && isset($pass) && isset($Fname) && isset($Lname) && isset($NIN) && isset($Address) && isset($PhoneNo) && isset($Email) && isset($TellerID)) {
         $db = new DbOperation();
        $responseData = array();
        $result = $db->createClient($CUsername,$pass, $Fname, $Lname, $NIN, $Address, $PhoneNo, $Email, $TellerID);
        if ($result == 0) {
            $responseData['success'] = 1;
        } elseif ($result == 1) {
            $responseData['success'] = 0;
        } elseif ($result == 2) {
            //$responseData['message'] = 'Client Username Taken!';
            $responseData['success'] = 0;
        }
        $response->getBody()->write(json_encode($responseData));
    }  else {
        $responseData = array();
        $responseData["type"] = 'error';
        $responseData["message"] = 'Required field(s) missing!';
        $response->getBody()->write(json_encode($responseData));
    }
});

// Registering a new client
$app->post('/clientRegister', function (Request $request, Response $response) {
    $json = $request->getBody();
    $requestData = json_decode($json, true);
    $CUsername = $requestData['username'];
    $pass = $requestData['password'];
    $Fname = $requestData['fname'];
    $Lname = $requestData['lname'];
    $NIN = $requestData['NIN'];
    $Address = $requestData['address'];
    $PhoneNo = $requestData['phone'];
    $Email = $requestData['email'];
    if(isset($CUsername) && isset($pass) && isset($Fname) && isset($Lname) && isset($NIN) && isset($Address) && isset($PhoneNo) && isset($Email)) {
         $db = new DbOperation();
        $responseData = array();
        $result = $db->clientRegister($CUsername,$pass, $Fname, $Lname, $NIN, $Address, $PhoneNo, $Email);
        if ($result == 0) {
            $responseData['success'] = 1;
        } elseif ($result == 1) {
            //$responseData['message'] = 'Errors!';
            $responseData['success'] = 0;
        } elseif ($result == 2) {
            //$responseData['message'] = 'Client Username Taken!';
            $responseData['success'] = 0;
        }
        $response->getBody()->write(json_encode($responseData));
    }  else {
        $responseData = array();
        $responseData["type"] = 'error';
        $responseData["message"] = 'Required field(s) missing!';
        $response->getBody()->write(json_encode($responseData));
    }
});

// Creating a new account
$app->post('/accountCreate', function (Request $request, Response $response) {
    $json = $request->getBody();
    $requestData = json_decode($json, true);
    $AcctType = $requestData['type'];
    $Currency = $requestData['currency'];
    $NIN = $requestData['NIN'];
    $ClientID = $requestData['id'];
    if(isset($AcctType) && isset($Currency) && isset($NIN) && isset($ClientID)) {
         $db = new DbOperation();
        $responseData = array();
        $result = $db->createAccount($AcctType, $Currency, $NIN, $ClientID);
        if ($result == 0) {
            $responseData['success'] = 1;
        } else {
            $responseData['success'] = 0;
        }
        $response->getBody()->write(json_encode($responseData));
    }  else {
        $responseData = array();
        $responseData["type"] = 'error';
        $responseData["message"] = 'Required field(s) missing!';
        $response->getBody()->write(json_encode($responseData));
    }
});

// Client login route
$app->post('/clientLogin', function (Request $request, Response $response) {
    $json = $request->getBody();
    $requestData = json_decode($json, true);
    $username = $requestData['username'];
    $password = $requestData['password'];
    if(isset($username) && isset($password)) {
        $db = new DbOperation();
        $responseData = array();
        $result = $db->clientLogin($username, $password);
        if ($result == 0) {
            $responseData['type'] = 'client';
            $responseData['change'] = 0;
            $responseData['id'] = $db->clientID($username);
        } elseif ($result == 1) {
            $responseData['type'] = 'client';
            $responseData['change'] = 1;
            $responseData['id'] = $db->clientID($username);
        } elseif ($result == 2) {
            $responseData['type'] = 'unknown';
            $responseData['change'] = 0;
            $responseData['id'] = NULL;
        } else {
            $responseData['type'] = 'unknown';
            $responseData['change'] = 0;
            $responseData['id'] = NULL;
        }
        $response->getBody()->write(json_encode($responseData));
    } else {
        $responseData = array();
        $responseData["type"] = 'unknown';
        $responseData["message"] = 'Required field(s) missing!';
        $response->getBody()->write(json_encode($responseData));
    }
});

// Client changing password
$app->post('/changeClientPass', function (Request $request, Response $response) {
    $json = $request->getBody();
    $requestData = json_decode($json, true);
    $username = $requestData['username'];
    $password = $requestData['password'];
    if(isset($username) && isset($password)) {
        $db = new DbOperation();
        $responseData = array();
        $result = $db->changeClientPass($username, $password);
        if ($result == 0) {
            $responseData['success'] = 1;
        } elseif ($result == 1) {
            $responseData['success'] = 0;
        } else {
            $responseData['success'] = 0;
        }
        $response->getBody()->write(json_encode($responseData));
    } else {
        $responseData = array();
        $responseData["type"] = 'error';
        $responseData["message"] = 'Required field(s) missing!';
        $response->getBody()->write(json_encode($responseData));
    }
});

// Client forgotten password
$app->post('/forgotClientPass', function (Request $request, Response $response) {
    $json = $request->getBody();
    $requestData = json_decode($json, true);
    $username = $requestData['username'];
    if(isset($username)) {
        $db = new DbOperation();
        $responseData = array();
        $result = $db->forgotClientPass($username);
        if ($result == 0) {
            $responseData['success'] = 1;
        } elseif ($result == 1) {
            $responseData['success'] = 0;
        } elseif ($result == 2) {
            $responseData['success'] = 0;
        }
        $response->getBody()->write(json_encode($responseData));
    }  else {
        $responseData = array();
        $responseData["type"] = 'error';
        $responseData["message"] = 'Required field(s) missing!';
        $response->getBody()->write(json_encode($responseData));
    }
});

// Getting client info using username
$app->post('/infoClient', function (Request $request, Response $response) {
    $json = $request->getBody();
    $requestData = json_decode($json, true);
    $username = $requestData['username'];
    if(isset($username)) {
        $db = new DbOperation();
        $client = $db->infoClient($username);
        $response->getBody()->write(json_encode($client));
    }
     else {
        $responseData = array();
        $responseData["type"] = 'error';
        $responseData["message"] = 'Required field(s) missing!';
        $response->getBody()->write(json_encode($responseData));
    }
});

// Getting list of client's accounts
$app->post('/getAccounts', function (Request $request, Response $response) {
    $json = $request->getBody();
    $requestData = json_decode($json, true);
    $clientID = $requestData['clientId'];
    if(isset($clientID)) {
        $db = new DbOperation();
        $accounts = $db->getAccounts($clientID);
        $response->getBody()->write(json_encode($accounts));
    } else {
        $responseData = array();
        $responseData["type"] = 'error';
        $responseData["message"] = 'Required field(s) missing!';
        $response->getBody()->write(json_encode($responseData));
    }
});

// For Tellers getting list of client's accounts using NIN
$app->post('/tellerAccounts', function (Request $request, Response $response) {
    $json = $request->getBody();
    $requestData = json_decode($json, true);
    $NIN = $requestData['NIN'];
    if(isset($NIN)) {
        $db = new DbOperation();
        $accounts = $db->tellerAccounts($NIN);
        $response->getBody()->write(json_encode($accounts));
    } else {
        $responseData = array();
        $responseData["type"] = 'error';
        $responseData["message"] = 'Required field(s) missing!';
        $response->getBody()->write(json_encode($responseData));
    }
});

// Getting list of account's transactions
$app->post('/getTransactions', function (Request $request, Response $response) {
    $json = $request->getBody();
    $requestData = json_decode($json, true);
    $AcctNo = $requestData['acctno'];
    if(isset($AcctNo)) {
        $db = new DbOperation();
        $transactions = $db->getTransactions($AcctNo);
        $response->getBody()->write(json_encode($transactions));
    } else {
        $responseData = array();
        $responseData["type"] = 'error';
        $responseData["message"] = 'Required field(s) missing!';
        $response->getBody()->write(json_encode($responseData));
    }
});

// Updating client contacts
$app->post('/updateContact', function (Request $request, Response $response) {
    $json = $request->getBody();
    $requestData = json_decode($json, true);
    $CUsername = $requestData['username'];
    $PhoneNo = $requestData['phone'];
    $Email = $requestData['email'];
    $Address = $requestData['address'];
    if(isset($CUsername) && isset($PhoneNo) && isset($Email) && isset($Address)) {
        $db = new DbOperation();
        $responseData = array();
        $result = $db->updateContacts($CUsername,$PhoneNo, $Email, $Address);
        if ($result == 0) {
            $responseData['success'] = 1;
        } elseif ($result == 1) {
            $responseData['success'] = 0;
        } else {
            $responseData['success'] = 0;
        }
        $response->getBody()->write(json_encode($responseData));
    } else {
        $responseData = array();
        $responseData["type"] = 'error';
        $responseData["message"] = 'Required field(s) missing!';
        $response->getBody()->write(json_encode($responseData));
    }
});


/******************************
* Transaction Functionalities *
******************************/
// Teller creating a new deposit
$app->post('/createDeposit', function (Request $request, Response $response) {
    $json = $request->getBody();
    $requestData = json_decode($json, true);
    $Amount = $requestData['amount'];
    $TellerID = $requestData['teller'];
    $AcctNo = $requestData['acctno'];
    if(isset($Amount) && isset($TellerID) && isset($AcctNo)) {
         $db = new DbOperation();
        $responseData = array();

        $result = $db->createDeposit($Amount, $TellerID, $AcctNo);

        if ($result == 0) {
            $responseData['success'] = 1;
        } else {
            $responseData['success'] = 0;
        }
        $response->getBody()->write(json_encode($responseData));
    }  else {
        $responseData = array();
        $responseData["type"] = 'error';
        $responseData["message"] = 'Required field(s) missing!';
        $response->getBody()->write(json_encode($responseData));
    }
});

// Teller creating a new withdrawl
$app->post('/createWithdrawl', function (Request $request, Response $response) {
    $json = $request->getBody();
    $requestData = json_decode($json, true);
    $Amount = $requestData['amount'];
    $TellerID = $requestData['teller'];
    $AcctNo = $requestData['acctno'];
    if(isset($Amount) && isset($TellerID) && isset($AcctNo)) {
        $db = new DbOperation();
        $responseData = array();
        $result = $db->createWithdrawl($Amount, $TellerID, $AcctNo);
        if ($result == 0) {
            $responseData['success'] = 1;
        } else {
            $responseData['success'] = 0;
        }
        $response->getBody()->write(json_encode($responseData));
    }  else {
        $responseData = array();
        $responseData["type"] = 'error';
        $responseData["message"] = 'Required field(s) missing!';
        $response->getBody()->write(json_encode($responseData));
    }
});

// Client creating a transfer transaction
$app->post('/createTransfer', function (Request $request, Response $response) {
    $json = $request->getBody();
    $requestData = json_decode($json, true);
    $Amount = $requestData['amount'];
    $ClientID = $requestData['client'];
    $from = $requestData['from'];
    $to = $requestData['to'];

    if(isset($Amount) && isset($ClientID) && isset($from) && isset($to)) {
         $db = new DbOperation();
        $responseData = array();
        $result = $db->createTransfer($Amount, $ClientID, $from, $to);
        if ($result == 0) {
            $responseData['success'] = 1;
        } else {
            $responseData['success'] = 0;
        } 
        $response->getBody()->write(json_encode($responseData));
    }  else {
        $responseData = array();
        $responseData["type"] = 'error';
        $responseData["message"] = 'Required field(s) missing!';
        $response->getBody()->write(json_encode($responseData));
    }
});


//getting messages for a user
$app->get('/messages/{id}', function (Request $request, Response $response) {
    $userid = $request->getAttribute('id');
    $db = new DbOperation();
    $messages = $db->getMessages($userid);
    $response->getBody()->write(json_encode(array("messages" => $messages)));
});

//updating a user
$app->post('/update/{id}', function (Request $request, Response $response) {
    if (areParametersAvailable(array('name', 'email', 'password', 'gender'))) {
        $id = $request->getAttribute('id');

        $requestData = $request->getParsedBody();

        $name = $requestData['name'];
        $email = $requestData['email'];
        $password = $requestData['password'];
        $gender = $requestData['gender'];


        $db = new DbOperation();
        $responseData = array();
        if ($db->updateProfile($id, $name, $email, $password, $gender)) {
            $responseData['error'] = false;
            $responseData['message'] = 'Updated successfully';
            $responseData['user'] = $db->getUserByEmail($email);
        } else {
            $responseData['error'] = true;
            $responseData['message'] = 'Not updated';
        }
        $response->getBody()->write(json_encode($responseData));
    }
});


//sending message to user
$app->post('/sendmessage', function (Request $request, Response $response) {
    if (areParametersAvailable(array('from', 'to', 'title', 'message'))) {
        $requestData = $request->getParsedBody();
        $from = $requestData['from'];
        $to = $requestData['to'];
        $title = $requestData['title'];
        $message = $requestData['message'];

        $db = new DbOperation();

        $responseData = array();

        if ($db->sendMessage($from, $to, $title, $message)) {
            $responseData['error'] = false;
            $responseData['message'] = 'Message sent successfully';
        } else {
            $responseData['error'] = true;
            $responseData['message'] = 'Could not send message';
        }

        $response->getBody()->write(json_encode($responseData));
    }
});

// Function to check parameters
function areParametersAvailable($required_fields)
{
    $error = false;
    $error_fields = "";
    $request_params = $_REQUEST;

    foreach ($required_fields as $field) {
        if (!isset($request_params[$field]) || strlen(trim($request_params[$field])) <= 0) {
            $error = true;
            $error_fields .= $field . ', ';
        }
    }

    if ($error) {
        $response = array();
        $response["error"] = true;
        $response["message"] = 'Required field(s) ' . substr($error_fields, 0, -2) . ' is missing or empty';
        echo json_encode($response);
        return false;
    }
    return true;
}

$app->run();

?>