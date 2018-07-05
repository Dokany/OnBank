//
//  ClientHomeViewController.swift
//  MY-Banking
//
/******************************************
 CSCE 253/2501
 Summer 2018
 Project 1
 
 Mohamed T Abdelrahman (ID no. 900142457)
 Yasmin ElDokany (ID no. 900131538)
 ******************************************/


import UIKit

internal class ClientHomeViewController: UIViewController, ChangePasswordDelegate, UpdateClientInfoDelegate, GetAccountsDelegate {
    var client_data: ClientData?
    var accounts: [Account]?
    
    var change_password_handler: ChangePasswordHandler?
    var update_client_info_handler: UpdateClientInfoHandler?
    var get_accounts_handler: GetAccountsHandler?
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var label_name: UILabel!
    @IBOutlet weak var label_id: UILabel!
    @IBOutlet weak var tf_phone: UITextField!
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var te_address: UITextView!
    
    @IBOutlet weak var tf_old_password: UITextField!
    @IBOutlet weak var tf_new_password: UITextField!
    @IBOutlet weak var tf_confirm_password: UITextField!
   
    func userDidAttemptChangePassword(result: Bool) {
        resumeInteraction()
       
        if result {
            self.client_data!.password = tf_new_password.text!
            AlertShower.showSuccessAlert(title: "Success", message: "Password Changed")
        } else {
            AlertShower.showErrorAlert(title: "Error", message: "Password Not Changed")
        }
        tf_confirm_password.text = ""
        tf_new_password.text = ""
        tf_old_password.text = ""
        
    }
    
    func clientDidAttemptChangeInfo(result: Bool) {
        if result {
            client_data?.address = te_address.text
            client_data?.email = tf_email.text
            client_data?.phone = tf_phone.text
            resumeInteraction()
            AlertShower.showSuccessAlert(title: "Success", message: "Contact Info Updated")
        } else {
            te_address.text = client_data?.address
            tf_email.text = client_data?.email
            tf_phone.text = client_data?.phone
            resumeInteraction()
            AlertShower.showErrorAlert(title: "Error", message: "Contact Info Not Updated")
        }
    }
    
    func accountsReceived(accounts: [Account]?) {
        self.resumeInteraction()
        self.accounts = accounts
        if accounts == nil {
            AlertShower.showErrorAlert(title: "Error", message: "No Accounts Found")
        } else {
            AlertShower.showSweetAlertAndExecute(onCondition: true, title: "Success", message: "\(String(self.accounts!.count)) Accounts Found", style: .success, buttonTitle: "OK", action: {(_ isOtherButton: Bool) -> Void in
                self.performSegue(withIdentifier: "client_to_accounts_segue", sender: nil)
                })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.hideKeyboard()
        label_name.text = client_data?.name
        label_id.text = client_data?.NIN
        tf_phone.text = client_data?.phone
        tf_email.text = client_data?.email
        te_address.text = client_data?.address
        change_password_handler = ChangePasswordHandler(delegate: self)
        update_client_info_handler = UpdateClientInfoHandler(delegate: self)
        get_accounts_handler = GetAccountsHandler(delegate: self)
        
        self.spinner.isHidden = true
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func pauseInteraction() {
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    func resumeInteraction() {
        self.spinner.isHidden = true
        self.spinner.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    @IBAction func updateContactInfo(_ sender: UIButton) {
        if let p = tf_phone.text {
            if p.count > 0 {
                if let e = tf_email.text {
                    if e.count > 0 {
                        if let a = te_address.text {
                            if a.count > 0 {
                                pauseInteraction()
                                update_client_info_handler?.updateInfo(username: client_data!.username!, phone: p, email: e, address: a)
                            } else {
                                AlertShower.showErrorAlert(title: "Incomplete Information", message: "Empty address field")
                            }
                        }
                    } else {
                        AlertShower.showErrorAlert(title: "Incomplete Information", message: "Empty email field")
                    }
                }
            } else {
                AlertShower.showErrorAlert(title: "Incomplete Information", message: "Empty phone field")
            }
        }
    }
    
    @IBAction func changePassword(_ sender: UIButton) {
        if let old_p = tf_old_password.text {
            if old_p.count > 0 {
                if let new_p = tf_new_password.text {
                    if new_p.count > 0 {
                        if let confirm_p = tf_confirm_password.text {
                            if confirm_p.count > 0 {
                                if confirm_p == new_p {
                                    if old_p == self.client_data!.password! {
                                        pauseInteraction()
                                        change_password_handler!.changePassword(username: client_data!.username!, password: new_p, type: "client")
                                    } else {
                                        AlertShower.showErrorAlert(title: "Error", message: "Incorrect old password")
                                    }
                                    
                                } else {
                                    AlertShower.showErrorAlert(title: "Error", message: "New password not identical in both fields")
                                }
                            } else {
                                 AlertShower.showErrorAlert(title: "Error", message: "Empty confirm field")
                            }
                        }
                        
                        
                    } else {
                        AlertShower.showErrorAlert(title: "Incomplete Information", message: "Please enter a valid new password")
                    }
                }
            } else {
                AlertShower.showErrorAlert(title: "Incomplete Information", message: "Please enter your old password")
            }
        }
        
    }
    @IBAction func accessAccounts(_ sender: UIButton) {
        self.pauseInteraction()
       // LogCat.printError(tag: "ClientHomeViewController", message: "\(client_data)")
        get_accounts_handler?.getAccounts(clientId: self.client_data!.clientId!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? AccountsViewController {
            destinationViewController.clientID = self.client_data!.clientId
            destinationViewController.accounts = self.accounts
            destinationViewController.from_client = true
        }
    }
}
