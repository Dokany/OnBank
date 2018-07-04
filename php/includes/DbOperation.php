<?php
/******************************************
CSCE 253/2501
Summer 2018
Project 1

Mohamed T Abdelrahman (ID no. 900142457)
Yasmin ElDokany (ID no. 900131538)
******************************************/

//Getting the smsController.php file
require_once dirname(__FILE__) . '/smsController.php';

class DbOperation
{
    //Database connection link
    private $con;

    //Class constructor
    function __construct()
    {
        //Getting the DbConnect.php file
        require_once dirname(__FILE__) . '/DbConnect.php';

        //Creating a DbConnect object to connect to the database
        $db = new DbConnect();

        //Initializing our connection link of this class
        //by calling the method connect of DbConnect class
        $this->con = $db->connect();
    }


    /********************************
    * Administrator Functionalities *
    *********************************/
    //Method to create a new administrator
    public function createAdmin($AUsername,$pass){
        //Check whether the admin is already registered or not
        if (!$this->isAdminExists($AUsername)) {
            //Encrypting the password
            $APassword = password_hash($pass, PASSWORD_BCRYPT);
            $ALastLogin = '0000-00-00 00:00:00';
            
            $stmt = $this->con->prepare("INSERT INTO administrator(AUsername, APassword, ALastLogin) values(?, ?, ?)");

            $stmt->bind_param("sss", $AUsername, $APassword, $ALastLogin);

            $result = $stmt->execute();

            $stmt->close();

            //If statement executed successfully
            if ($result) {
                //Returning 0 means admin created successfully
                return 0;
            } else {
                //Returning 1 means failed to create admin
                return 1;
            }
        } else {
            //returning 2 means admin already exist in the database
            return 2;
        }
    }

    //This method to return adminID
    public function adminID($username){
        $stmt = $this->con->prepare("SELECT AdminID FROM administrator WHERE AUsername = ?");
        $stmt->bind_param("s", $username);
        $stmt->execute();
        $stmt->bind_result($admin);
        $stmt->fetch();
        return $admin;
    }

    // Method to update admins's login timestamp
    private function aLastLogin($AUsername) {
        $stmt = $this->con->prepare("UPDATE administrator SET ALastLogin = CURRENT_TIMESTAMP  WHERE AUsername = ?");
        $stmt->bind_param("s", $AUsername);
        $result = $stmt->execute();
        $stmt->close();
        //If statement executed successfully
        if ($result) {
            //Returning 0 means admin's last login timestamp updated successfully
            return 0;
        } else {
            //Returning 1 means failed to change admin's last login timestamp
            return 1;
        }
    }

    //Method to log in admin
    public function adminLogin($AUsername,$pass){
        $stmt = $this->con->prepare("SELECT APassword FROM administrator WHERE AUsername = ?");
        
        $stmt->bind_param("s",$AUsername);
        
        $stmt->execute();

        $stmt->store_result();

        $stmt->bind_result($col1);

        //Getting the number of retrieved rows
        $num_rows = $stmt->num_rows;

        if ($num_rows > 0) {
            $stmt->fetch();
            if (password_verify($pass, $col1)) {
                // User exists and has a valid password
                $this->aLastLogin($AUsername);
                return 0;
            } else {
                // User exists but has an invalid password
                return 1;
            }
        } else {
            // User doesn't exist
            return 2;
        }
    }

    //Method to delete admin
    public function adminDelete($AUsername){
        //Check whether the admin is already registered or not
        if ($this->isAdminExists($AUsername)) {
            $stmt = $this->con->prepare("DELETE FROM administrator WHERE AUsername=?");
        
            $stmt->bind_param("s",$AUsername);
            
            $stmt->execute();
            
            $result = $stmt->store_result();
            
            $stmt->close();
            
            //If statement executed successfully
            if ($result) {
                //Returning 0 means admin deleted successfully
                return 0;
            } else {
                //Returning 1 means failed to delete admin
                return 1;
            }
        } else {
            //returning 2 means admin doesn't exist in the database
            return 2;
        }
    }

    //Method to change administrator password
    public function changeAdminPass($AUsername,$newPass){
        //Check whether or not the admin is registered
        if ($this->isAdminExists($AUsername)) {
            //Encrypting the password
            $APassword = password_hash($newPass, PASSWORD_BCRYPT);

            $stmt = $this->con->prepare("UPDATE administrator SET APassword = ? WHERE AUsername = ?");

            $stmt->bind_param("ss", $APassword, $AUsername);

            $stmt->execute();

            $result = $stmt->store_result();
            
            $stmt->close();

            //If statement executed successfully
            if ($result) {
                //Returning 0 means admin password changed successfully
                return 0;
            } else {
                //Returning 1 means failed to change admin's password
                return 1;
            }
        } else {
            //returning 2 means admin doesn't exist in the database
            return 2;
        }
    }

    //This method will return all admins
    public function getAdmins(){
        $stmt = $this->con->prepare("SELECT AdminID, AUsername, ALastLogin FROM administrator");
        $stmt->execute();
        $stmt->store_result();
        $stmt->bind_result($AdminID, $AUsername, $ALastLogin);
        // Getting the number of retrieved rows
        $num_rows = $stmt->num_rows;
        // Getting admins result array
        $admins = array();
        $admins['number'] = $num_rows;
        while ($stmt->fetch()) {
            $temp = array();
            $temp['id'] = $AdminID;
            $temp['username'] = $AUsername;
            $temp['last_login'] = $ALastLogin;
            array_push($admins, $temp);
        }
        return $admins;
    }

        // Method to return all pending client online banking applications
    public function pendingClients(){
        $stmt = $this->con->prepare("SELECT NIN, Fname, Lname FROM client WHERE (AdminID IS NULL AND TellerID IS NULL)");
        $stmt->execute();
        $stmt->store_result();
        $stmt->bind_result($NIN, $Fname, $Lname);
        // Getting the number of retrieved rows
        $num_rows = $stmt->num_rows;
        // Getting clients result array
        $clients = array();
        $clients['number'] = $num_rows;
        while ($stmt->fetch()) {
            $temp = array();
            $temp['NIN'] = $NIN;
            $temp['name'] = $Fname.' '.$Lname;
            array_push($clients, $temp);
        }
        return $clients;
    }

    //This method will return single pending client online banking application
    public function viewPending($NIN){
        $stmt = $this->con->prepare("SELECT CUsername, Fname, Lname, Address, PhoneNo, Email FROM client WHERE NIN = ?");
        $stmt->bind_param("s", $NIN);
        $stmt->execute();
        $stmt->bind_result($CUsername, $Fname, $Lname, $Address, $PhoneNo, $Email);
        $stmt->fetch();
        // Getting client result array
        $client = array();
        $client['username'] = $CUsername;
        $client['name'] = $Fname.' '.$Lname;
        $client['address'] = $Address;
        $client['phone'] = $PhoneNo;
        $client['email'] = $Email;
        return $client;
    }

    //This method will return owner info
    public function viewOwner($NIN){
        $stmt = $this->con->prepare("SELECT Fname, Lname FROM owner_info WHERE NIN = ?");
        $stmt->bind_param("s", $NIN);
        $stmt->execute();
        $stmt->bind_result($Fname, $Lname);
        $stmt->fetch();
        return $Fname.' '.$Lname;
    }

    //This method to approve pending client online banking application
    public function approvePending($AdminID, $NIN){
        $stmt = $this->con->prepare("UPDATE client SET AdminID = ?  WHERE NIN = ?");
        $stmt->bind_param("is", $AdminID, $NIN);
        $result = $stmt->execute();
        $stmt->close();
        //If statement executed successfully
        if ($result) {
            //Returning 0 means client's application was accepted
            // Creating a SmsController object to send sms
            $sms = new SmsController();
            //$sms->sendSms('Your OnBank account has been approved.');
            return 0;
        } else {
            //Returning 1 means failed to accept client's application
            return 1;
        };
    }

    //Checking whether a admin already exists
    private function isAdminExists($AUsername) {
        $stmt = $this->con->prepare("SELECT AdminID FROM administrator WHERE AUsername = ?");
        $stmt->bind_param("s", $AUsername);
        $stmt->execute();
        $stmt->store_result();
        $num_rows = $stmt->num_rows;
        $stmt->close();
        return $num_rows > 0;
    }


    /*************************
    * Teller Functionalities *
    *************************/
    //Method to create a new teller
    public function createTeller($TUsername,$pass){
        //Check whether or not the teller is registered
        if (!$this->isTellerExists($TUsername)) {
            //Encrypting the password
            $TPassword = password_hash($pass, PASSWORD_BCRYPT);
            $TLastLogin = '0000-00-00 00:00:00';
            $stmt = $this->con->prepare("INSERT INTO teller(TUsername, TPassword, TLastLogin) VALUES(?, ?, ?)");
            $stmt->bind_param("sss", $TUsername, $TPassword, $TLastLogin);
            $result = $stmt->execute();
            $stmt->close();
            //If statement executed successfully
            if ($result) {
                //Returning 0 means teller created successfully
                return 0;
            } else {
                //Returning 1 means failed to create teller
                return 1;
            }
        } else {
            //returning 2 means teller already exist in the database
            return 2;
        }
    }

    // Method to return tellerID
    public function tellerID($username){
        $stmt = $this->con->prepare("SELECT TellerID FROM teller WHERE TUsername = ?");
        $stmt->bind_param("s", $username);
        $stmt->execute();
        $stmt->bind_result($teller);
        $stmt->fetch();
        return $teller;
    }

    // Method to update teller's login timestamp
    private function tLastLogin($TUsername) {
        $stmt = $this->con->prepare("UPDATE teller SET TLastLogin = CURRENT_TIMESTAMP  WHERE TUsername = ?");
        $stmt->bind_param("s", $TUsername);
        $result = $stmt->execute();
        $stmt->close();
        //If statement executed successfully
        if ($result) {
            //Returning 0 means teller's last login timestamp updated successfully
            return 0;
        } else {
            //Returning 1 means failed to change teller's last login timestamp
            return 1;
        }
    }

    //Method to log in teller
    public function tellerLogin($TUsername,$pass){
        $stmt = $this->con->prepare("SELECT TPassword, TLastLogin FROM teller WHERE TUsername=?");
        $stmt->bind_param("s",$TUsername);
        $stmt->execute();
        $stmt->store_result();
        $stmt->bind_result($col1, $col2);
        // Getting the number of retrieved rows
        $num_rows = $stmt->num_rows;
        if ($num_rows > 0) {
            $stmt->fetch();
            if (password_verify($pass, $col1)) {
                // User exists and has a valid password
                if ($col2 === '0000-00-00 00:00:00') {
                    //  First login - must change password_hash
                    $this->tLastLogin($TUsername);
                    return 1;
                } else {
                    // Successful login
                    $this->tLastLogin($TUsername);
                    return 0;
                }
            } else {
                // User exists but has an invalid password
                return 2;
            }
        } else {
            // User doesn't exist
            return 3;
        }
    }

    //Method to delete teller
    public function tellerDelete($TUsername){
        //Check whether the teller is already registered or not
        if ($this->isTellerExists($TUsername)) {
            $stmt = $this->con->prepare("DELETE FROM teller WHERE TUsername=?");
            $stmt->bind_param("s",$TUsername);
            $stmt->execute();
            $result = $stmt->store_result();
            $stmt->close();
            //If statement executed successfully
            if ($result) {
                //Returning 0 means teller deleted successfully
                return 0;
            } else {
                //Returning 1 means failed to delete teller
                return 1;
            }
        } else {
            //returning 2 means teller doesn't exist in the database
            return 2;
        }
    }

    //This method will return all tellers
    public function getTellers(){
        $stmt = $this->con->prepare("SELECT TellerID, TUsername, TLastLogin FROM teller");
        $stmt->execute();
        $stmt->store_result();
        $stmt->bind_result($TellerID, $TUsername, $TLastLogin);
        // Getting the number of retrieved rows
        $num_rows = $stmt->num_rows;
        // Getting admins result array
        $tellers = array();
        $tellers['number'] = $num_rows;
        while ($stmt->fetch()) {
            $temp = array();
            $temp['id'] = $TellerID;
            $temp['username'] = $TUsername;
            $temp['last_login'] = $TLastLogin;
            array_push($tellers, $temp);
        }
        return $tellers;
    }

    //Method to change teller password
    public function changeTellerPass($TUsername,$newPass){
        //Check whether or not the teller is registered
        if ($this->isTellerExists($TUsername)) {
            //Encrypting the password
            $TPassword = password_hash($newPass, PASSWORD_BCRYPT);
            $stmt = $this->con->prepare("UPDATE teller SET TPassword = ? WHERE TUsername = ?");
            $stmt->bind_param("ss", $TPassword, $TUsername);
            $result = $stmt->execute();
            $stmt->close();
            //If statement executed successfully
            if ($result) {
                //Returning 0 means teller password changed successfully
                return 0;
            } else {
                //Returning 1 means failed to change teller's password
                return 1;
            }
        } else {
            //returning 2 means teller doesn't exist in the database
            return 2;
        }
    }

    //Checking whether a teller already exists
    private function isTellerExists($TUsername) {
        $stmt = $this->con->prepare("SELECT TellerID FROM teller WHERE TUsername = ?");
        $stmt->bind_param("s", $TUsername);
        $stmt->execute();
        $stmt->store_result();
        $num_rows = $stmt->num_rows;
        $stmt->close();
        return $num_rows > 0;
    }


    /******************************
    * Transaction Functionalities *
    ******************************/
    //Method to get transactions list and the teller that performed them (rows with NULL TellerID values are transfers by clients)
    public function getAllTransactions(){
        $stmt = $this->con->prepare("SELECT TransactionNo, TDate, Amount, AcctNo, TellerID FROM transaction");
        $stmt->execute();
        $stmt->store_result();
        $stmt->bind_result($TransactionNo, $TDate, $Amount, $AcctNo, $TellerID);
        // Getting the number of retrieved rows
        $num_rows = $stmt->num_rows;
        // Getting transactions result array
        $transactions = array();
        $transactions['number'] = $num_rows;
        while ($stmt->fetch()) {
            $temp = array();
            $temp['id'] = $TransactionNo;
            $temp['date'] = $TDate;
            $temp['amount'] = $Amount;
            $temp['acctno'] = $AcctNo;
            $temp['currency'] = $this->accountCurrency($AcctNo);
            $temp['teller'] = $TellerID;
            array_push($transactions, $temp);
        }
        return $transactions;
    }

    // Method to get transactions of account
    public function getTransactions($AcctNo){
        $stmt = $this->con->prepare("SELECT TransactionNo, TDate, Amount, TellerID FROM transaction WHERE AcctNo=?");
        $stmt->bind_param("i",$AcctNo);
        $stmt->execute();
        $stmt->store_result();
        $stmt->bind_result($TransactionNo, $TDate, $Amount, $TellerID);
        // Getting the number of retrieved rows
        $num_rows = $stmt->num_rows;
        // Getting transactions result array
        $transactions = array();
        $transactions['number'] = $num_rows;
        while ($stmt->fetch()) {
            $temp = array();
            $temp['id'] = $TransactionNo;
            $temp['date'] = $TDate;
            $temp['amount'] = $Amount;
            $temp['teller'] = $TellerID;
            array_push($transactions, $temp);
        }
        return $transactions;
    }

    // Method to update balance with new deposit/withdrawl amount
    private function balanceUpdate($Amount, $AcctNo) {
        $stmt = $this->con->prepare("UPDATE account SET Balance = Balance + ? WHERE AcctNo = ?");
        $stmt->bind_param("di", $Amount, $AcctNo);
        $result = $stmt->execute();
        $stmt->close();
        //If statement executed successfully
        if ($result) {
            // Returning 1 means update succeeded
            return 1;
        } else {
            // Returning 0 means update failed
            return 0;
        }
    }

    // Method to get account's currency
    private function accountCurrency($AcctNo) {
        $stmt = $this->con->prepare("SELECT Abbreviation FROM account WHERE AcctNo = ?");
        $stmt->bind_param("i", $AcctNo);
        $stmt->execute();
        $stmt->bind_result($Currency);
        $stmt->fetch();
        return $Currency;
    }

    // Method to get transaction amount with exchange rate
    private function exchangeRate($Amount, $from, $to) {
        $stmt = $this->con->prepare("SELECT ExchangeRate FROM currency_exchange WHERE CurrentAbbr = ? AND NewAbbr = ?");
        $stmt->bind_param("ss", $from, $to);
        $stmt->execute();
        $stmt->bind_result($Rate);
        $stmt->fetch();
        return ($Amount * $Rate);
    }

    // Method to create new deposit
    public function createDeposit($Amount, $TellerID, $AcctNo){
        $stmt = $this->con->prepare("INSERT INTO transaction(Amount, AcctNo, TellerID) VALUES(?, ?, ?)");
        $stmt->bind_param("dii", $Amount, $AcctNo, $TellerID);
        $result = $stmt->execute();
        $stmt->close();
        //If statement executed successfully
        if ($result and $this->balanceUpdate($Amount, $AcctNo)) {
            // Returning 0 means deposit created successfully
            // Creating a SmsController object to send sms
            $sms = new SmsController();
            //$sms->sendSms('Your OnBank deposit of '.$Amount.' is confirmed.');
            return 0;
        } else {
            // Returning 1 means failed to create deposit
            return 1;
        }
    }

    // Method to create new withdrawl
    public function createWithdrawl($Amount, $TellerID, $AcctNo){
        $Amount = -1 * $Amount;
        $stmt = $this->con->prepare("INSERT INTO transaction(Amount, AcctNo, TellerID) VALUES(?, ?, ?)");
        $stmt->bind_param("dii", $Amount, $AcctNo, $TellerID);
        $result = $stmt->execute();
        $stmt->close();
        //If statement executed successfully
        if ($result and $this->balanceUpdate($Amount, $AcctNo)) {
            // Returning 0 means withdrawl created successfully
            // Creating a SmsController object to send sms
            $sms = new SmsController();
            //$sms->sendSms('Your OnBank deposit of '.$Amount.' is confirmed.');
            return 0;
        } else {
            //Returning 1 means failed to create withdrawl
            return 1;
        }
    }

    // Method to create new transfer
    public function createTransfer($Amount, $ClientID, $from, $to){
        // createDeposit
        $currency_from = $this->accountCurrency($from);
        $currency_to = $this->accountCurrency($to);
        $DepositAmount = ($currency_from == $currency_to)? $Amount : $this->exchangeRate($Amount, $currency_from, $currency_to); 
        $stmt = $this->con->prepare("INSERT INTO transaction(Amount, AcctNo, ClientID) VALUES(?, ?, ?)");
        $stmt->bind_param("dii", $DepositAmount, $to, $ClientID);
        $result = $stmt->execute();
        $stmt->close();
        $result2 = $this->balanceUpdate($DepositAmount, $to);

        // Withdrawl
        $WithdrawlAmount = -1 * $Amount;
        $stmt = $this->con->prepare("INSERT INTO transaction(Amount, AcctNo, ClientID) VALUES(?, ?, ?)");
        $stmt->bind_param("dii", $WithdrawlAmount, $from, $ClientID);
        $result3 = $stmt->execute();
        $stmt->close();
        $result4 = $this->balanceUpdate($WithdrawlAmount, $from);

        //If statement executed successfully
        if ($result and $result2 and $result3 and $result4) {
            // Returning 0 means withdrawl created successfully
            // Creating a SmsController object to send sms
            $sms = new SmsController();
            //$sms->sendSms('Your OnBank transfer of '.$Amount.' is confirmed.');
            return 0;
        } else {
            //Returning 1 means failed to create withdrawl
            return 1;
        }
    }

    /*************************
    * Client Functionalities *
    *************************/
    // Method for tellers to create a new client
    public function createClient($CUsername,$pass, $Fname, $Lname, $NIN, $Address, $PhoneNo, $Email, $TellerID){
        // Check whether or not the client is registered
        if (!$this->isClientExists($CUsername)) {
            // Encrypting the password
            $CPassword = password_hash($pass, PASSWORD_BCRYPT);
            $stmt = $this->con->prepare("INSERT INTO client(CUsername, CPassword, Fname, Lname, NIN, Address, PhoneNo, Email, TellerID) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)");
            $stmt->bind_param("sssssssss", $CUsername, $CPassword, $Fname, $Lname, $NIN, $Address, $PhoneNo, $Email, $TellerID);
            $result = $stmt->execute();
            $stmt->close();
            // If statement executed successfully
            if ($result) {
                // Returning 0 means client created successfully
                return 0;
            } else {
                // Returning 1 means client to create teller
                return 1;
            }
        } else {
            // Returning 2 means client already exist in the database
            return 2;
        }
    }

    //This method to return clientID
    public function clientID($username){
        $stmt = $this->con->prepare("SELECT ClientID FROM client WHERE CUsername = ?");
        $stmt->bind_param("s", $username);
        $stmt->execute();
        $stmt->bind_result($client);
        $stmt->fetch();
        return $client;
    }

    // Method to update client's login timestamp
    private function cLastLogin($CUsername) {
        $stmt = $this->con->prepare("UPDATE client SET CLastLogin = CURRENT_TIMESTAMP  WHERE CUsername = ?");
        $stmt->bind_param("s", $CUsername);
        $result = $stmt->execute();
        $stmt->close();
        //If statement executed successfully
        if ($result) {
            //Returning 0 means client's last login timestamp updated successfully
            return 0;
        } else {
            //Returning 1 means failed to change client's last login timestamp
            return 1;
        }
    }

    //Method to log in client
    public function clientLogin($CUsername,$pass){
        $stmt = $this->con->prepare("SELECT CPassword, CLastLogin FROM client WHERE CUsername=? AND (AdminID IS NOT NULL OR TellerID IS NOT NULL)");
        $stmt->bind_param("s",$CUsername);
        $stmt->execute();
        $stmt->store_result();
        $stmt->bind_result($col1, $col2);
        // Getting the number of retrieved rows
        $num_rows = $stmt->num_rows;
        if ($num_rows > 0) {
            $stmt->fetch();
            if (password_verify($pass, $col1)) {
                // User exists and has a valid password
                if ($col2 === '0000-00-00 00:00:00') {
                    //  First login - must change password
                    $this->cLastLogin($CUsername);
                    return 1;
                } else {
                    // Successful login
                    $this->cLastLogin($CUsername);
                    return 0;
                }
            } else {
                // User exists but has an invalid password
                return 2;
            }
        } else {
            // User doesn't exist
            return 3;
        }
    }

    // Method to register client's online banking application
    public function clientRegister($CUsername,$pass, $Fname, $Lname, $NIN, $Address, $PhoneNo, $Email){
        // Check whether or not the client is registered
        if (!$this->isClientExists($CUsername)) {
            // Encrypting the password
            $CPassword = password_hash($pass, PASSWORD_BCRYPT);
            $stmt = $this->con->prepare("INSERT INTO client(CUsername, CPassword, Fname, Lname, NIN, Address, PhoneNo, Email) VALUES(?, ?, ?, ?, ?, ?, ?, ?)");
            $stmt->bind_param("ssssssss", $CUsername, $CPassword, $Fname, $Lname, $NIN, $Address, $PhoneNo, $Email);
            $result = $stmt->execute();
            $stmt->close();
            // If statement executed successfully
            if ($result) {
                // Returning 0 means client created successfully
                return 0;
            } else {
                // Returning 1 means client to create teller
                return 1;
            }
        } else {
            // Returning 2 means client already exist in the database
            return 2;
        }
    }

    //Method to change client password
    public function changeClientPass($CUsername,$newPass){
        //Check whether or not the client is registered
        if ($this->isClientExists($CUsername)) {
            //Encrypting the password
            $CPassword = password_hash($newPass, PASSWORD_BCRYPT);

            $stmt = $this->con->prepare("UPDATE client SET CPassword = ? WHERE CUsername = ?");

            $stmt->bind_param("ss", $CPassword, $CUsername);

            $result = $stmt->execute();

            $stmt->close();

            //If statement executed successfully
            if ($result) {
                //Returning 0 means client password changed successfully
                return 0;
            } else {
                //Returning 1 means failed to change client's password
                return 1;
            }
        } else {
            //returning 2 means client doesn't exist in the database
            return 2;
        }
    }

    //Method to change client contact info
    public function updateContacts($CUsername,$PhoneNo, $Email, $Address){
        //Check whether or not the client is registered
        if ($this->isClientExists($CUsername)) {
            //Encrypting the password
            $CPassword = password_hash($newPass, PASSWORD_BCRYPT);

            $stmt = $this->con->prepare("UPDATE client SET PhoneNo = ?, Email = ?, Address = ? WHERE CUsername = ?");

            $stmt->bind_param("ssss", $PhoneNo, $Email, $Address, $CUsername);

            $result = $stmt->execute();

            $stmt->close();

            //If statement executed successfully
            if ($result) {
                //Returning 0 means client contacts changed successfully
                return 0;
            } else {
                //Returning 1 means failed to change client's contacts
                return 1;
            }
        } else {
            //returning 2 means client doesn't exist in the database
            return 2;
        }
    }

    // Method to generate new password for client
    public function forgotClientPass($CUsername){
        // Check whether or not the client is registered
        if ($this->isClientExists($CUsername)) {
            // Generating random password
            $data = '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcefghijklmnopqrstuvwxyz';
            $newPass = substr(str_shuffle($data), 0, 7);
            $CPassword = password_hash($newPass, PASSWORD_BCRYPT);
            $stmt = $this->con->prepare("UPDATE client SET CPassword = ?, CLastLogin = '0000-00-00 00:00:00' WHERE CUsername = ?");
            $stmt->bind_param("ss", $CPassword, $CUsername);
            $stmt->execute();
            $result = $stmt->store_result();
            $stmt->close();
            //If statement executed successfully
            if ($result) {
                // Returning 0 means client password changed successfully
                // Creating a SmsController object to send sms
                $sms = new SmsController();
                //$sms->sendSms('Hello, your OnBank temporary password: '.$newPass);
                return 0;
            } else {
                // Returning 1 means failed to change client's password
                return 1;
            }
        } else {
            // Returning 2 means client doesn't exist in the database
            return 2;
        }
    }

    //This method will return client info for client
    public function infoClient($username){
        $stmt = $this->con->prepare("SELECT NIN, Fname, Lname, Address, PhoneNo, Email FROM client WHERE CUsername = ?");
        $stmt->bind_param("s", $username);
        $stmt->execute();
        $stmt->store_result();
        $stmt->bind_result($NIN, $Fname, $Lname, $Address, $PhoneNo, $Email);
        $stmt->fetch();
        // Getting client result array
        $client = array();
        $client['NIN'] = $NIN;
        $client['name'] = $Fname.' '.$Lname;
        $client['address'] = $Address;
        $client['phone'] = $PhoneNo;
        $client['email'] = $Email;
        return $client;
    }

    // Method for tellers to create a new account
    public function createAccount($AcctType, $Currency, $NIN, $ClientID){
        $stmt = $this->con->prepare("INSERT INTO account(AcctType, Balance, Abbreviation, NIN, ClientID) VALUES(?, 0, ?, ?, ?)");
            $stmt->bind_param("ssii", $AcctType, $Currency, $NIN, $ClientID);
            $result = $stmt->execute();
            $stmt->close();
            // If statement executed successfully
            if ($result) {
                // Returning 0 means account created successfully
                return 0;
            } else {
                // Returning 1 means failure to create new account
                return 1;
            }
    }

    // Method to get list of client's accounts
    public function getAccounts($clientID){
        $stmt = $this->con->prepare("SELECT AcctNo, Balance, Abbreviation, AcctType FROM account WHERE ClientID = ?");
        $stmt->bind_param("i", $clientID);
        $stmt->execute();
        $stmt->store_result();
        $stmt->bind_result($AcctNo, $Balance, $Abbreviation, $AcctType);
        // Getting the number of retrieved rows
        $num_rows = $stmt->num_rows;
        // Getting client's accounts result array
        $accounts = array();
        $accounts['number'] = $num_rows;
        while ($stmt->fetch()) {
            $temp = array();
            $temp['acctno'] = $AcctNo;
            $temp['balance'] = $Balance;
            $temp['currency'] = $Abbreviation;
            $temp['type'] = $AcctType;
            array_push($accounts, $temp);
        }
        return $accounts;
    }

    // Method to get list of client's accounts using NIN
    public function tellerAccounts($NIN){
        $stmt = $this->con->prepare("SELECT AcctNo, Balance, Abbreviation, AcctType FROM account WHERE NIN = ?");
        $stmt->bind_param("i", $NIN);
        $stmt->execute();
        $stmt->store_result();
        $stmt->bind_result($AcctNo, $Balance, $Abbreviation, $AcctType);
        // Getting the number of retrieved rows
        $num_rows = $stmt->num_rows;
        // Getting client's accounts result array
        $accounts = array();
        $accounts['number'] = $num_rows;
        while ($stmt->fetch()) {
            $temp = array();
            $temp['acctno'] = $AcctNo;
            $temp['balance'] = $Balance;
            $temp['currency'] = $Abbreviation;
            $temp['type'] = $AcctType;
            array_push($accounts, $temp);
        }
        return $accounts;
    }

    //Checking whether a client already exists
    private function isClientExists($CUsername) {
        $stmt = $this->con->prepare("SELECT ClientID FROM client WHERE CUsername = ?");
        $stmt->bind_param("s", $CUsername);
        $stmt->execute();
        $stmt->store_result();
        $num_rows = $stmt->num_rows;
        $stmt->close();
        return $num_rows > 0;
    }
} // End of file
?>