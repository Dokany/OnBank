//
//  TellerViewController.swift
//  MY-Banking
//
/******************************************
 CSCE 253/2501
 Summer 2018
 Project 1
 
 Mohamed T Abdelrahman (ID no. 900142457)
 Yasmin ElDokany (ID no. 900131538)
 ******************************************/


import Foundation
import UIKit

internal class TellerViewController: UIViewController, AddAccountDelegate, GetAccountsDelegate, AddClientDelegate {
    var tellerId: Int?
    var clientId: Int?
    var add_account_handler: AddAccountHandler?
    var get_accounts_handler: GetAccountsHandler?
    var add_client_handler: AddClientHandler?
    var accounts: [Account]?
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var clientId_tf: UITextField!
    @IBOutlet weak var nationalId_tf: UITextField!
    @IBOutlet weak var email_tf: UITextField!
    @IBOutlet weak var firstName_tf: UITextField!
    @IBOutlet weak var lastName_tf: UITextField!
    @IBOutlet weak var phone_tf: UITextField!
    @IBOutlet weak var username_tf: UITextField!
    @IBOutlet weak var password_tf: UITextField!
    @IBOutlet weak var address_te: UITextView!
    
    @IBOutlet weak var firstNationalId_tf: UITextField!
    override func viewWillAppear(_ animated: Bool) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.hideKeyboard()
        spinner.isHidden = true
        add_account_handler = AddAccountHandler(delegate: self)
        get_accounts_handler = GetAccountsHandler(delegate: self)
        add_client_handler = AddClientHandler(delegate: self)
        
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
    
    @IBAction func viewAccounts(_ sender: UIButton) {
        if let id = clientId_tf?.text {
            if let clientId = Int(id) {
                self.pauseInteraction()
                get_accounts_handler!.getAccounts(clientId: clientId)
            } else {
                AlertShower.showErrorAlert(title: "Error", message: "Incorrect Client Id")
            }
        } else {
            AlertShower.showErrorAlert(title: "Error", message: "Incorrect Client Id")
        }
    }
    
    func addAccount(type: AccountType) {
        if let id = clientId_tf?.text {
            if let clientId = Int(id) {
                if let nin = firstNationalId_tf?.text {
                    if nin.count > 0 {
                        var currency = API_AddAccount.EGP
                        
                        AlertShower.showSweetAlert(onCondition: true, title: "Choose Currency", message: nil, style: .none, buttonTitle: "EGP", otherButtonTitle: "Foreign", action: {(isOtherButton: Bool) -> Void in
                            if !isOtherButton {
                                AlertShower.showSweetAlert(onCondition: true, title: "Choose Currency", message: nil, style: .none, buttonTitle: "USD", otherButtonTitle: "EUR", action: {(isThirdButton: Bool) -> Void in
                                    if !isThirdButton {
                                        currency = API_AddAccount.EUR
                                    } else {
                                        currency = API_AddAccount.USD
                                    }
                                    LogCat.printError(tag: "TellerViewController", message: "Currency = \(currency)")
                                    self.pauseInteraction()
                                    self.add_account_handler!.addAccount(clientId: clientId, NIN: nin, type: type, currency: currency)
                                })
                            } else {
                                currency = API_AddAccount.EGP
                                LogCat.printError(tag: "TellerViewController", message: "Currency = \(currency)")
                                self.pauseInteraction()
                                self.add_account_handler!.addAccount(clientId: clientId, NIN: nin, type: type, currency: currency)
                            }
                        })
                        
                    } else {
                        AlertShower.showErrorAlert(title: "Error", message: "Incorrect National Id")
                    }
                } else {
                    AlertShower.showErrorAlert(title: "Error", message: "Incorrect National Id")
                }
                
            } else {
                AlertShower.showErrorAlert(title: "Error", message: "Incorrect Client Id")
            }
        } else {
            AlertShower.showErrorAlert(title: "Error", message: "Incorrect Client Id")
        }
        
    }
    
    @IBAction func newCurrentAccount(_ sender: UIButton) {
        self.addAccount(type: .Current)
    }
    @IBAction func newSavingsAccount(_ sender: UIButton) {
        self.addAccount(type: .Savings)
    }
    @IBAction func addClient(_ sender: UIButton) {
        if let nin = nationalId_tf.text {
            if let e = email_tf.text {
                if let f = firstName_tf.text {
                    if let l = lastName_tf.text {
                        if let h = phone_tf.text {
                            if let u = username_tf.text {
                                if let p = password_tf.text {
                                    if let a = address_te.text {
                                        if nin.count > 0 && e.count > 0 && f.count > 0 && l.count > 0 && h.count > 0 && u.count > 0 && p.count > 0 && a.count > 0 {
                                            pauseInteraction()
                                            add_client_handler?.addClient(tellerId: tellerId!, NIN: nin, username: u, password: p, email: e, phone: h, first_name: f, last_name: l, address: address_te.text)
                                            return;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        AlertShower.showErrorAlert(title: "Error", message: "Invalid Form")
    }
    
    func clearTexts() {
        return;
        clientId_tf.text = ""
        firstNationalId_tf.text = ""
        nationalId_tf.text = ""
        email_tf.text = ""
        firstName_tf.text = ""
        lastName_tf.text = ""
        phone_tf.text = ""
        username_tf.text = ""
        password_tf.text = ""
        address_te.text = ""
    }
    
    func onAccountAdded(result: Bool) {
        clientId = Int(self.clientId_tf.text!)
        clearTexts()
        resumeInteraction()
        if result {
            AlertShower.showSuccessAlert(title: "Success", message: "Account Added")
        } else {
            AlertShower.showErrorAlert(title: "Error", message: "Account Not Added")
        }
    }
    func onClientAdded(result: Bool) {
        clearTexts()
        
        resumeInteraction()
        if result {
            AlertShower.showSuccessAlert(title: "Success", message: "Client Added")
        } else {
            AlertShower.showErrorAlert(title: "Error", message: "Client Not Added")
        }
    }
    
    func accountsReceived(accounts: [Account]?) {
        clientId = Int(self.clientId_tf.text!)
        clientId_tf.text = ""
        self.resumeInteraction()
        self.accounts = accounts
        if accounts == nil {
            AlertShower.showErrorAlert(title: "Error", message: "No Accounts Found")
        } else {
            AlertShower.showSweetAlertAndExecute(onCondition: true, title: "Success", message: "\(String(self.accounts!.count)) Accounts Found", style: .success, buttonTitle: "OK", action: {(_ isOtherButton: Bool) -> Void in
                self.performSegue(withIdentifier: "teller_accounts_segue", sender: nil)
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? AccountsViewController {
            destinationViewController.clientID = self.clientId
            destinationViewController.accounts = self.accounts
            destinationViewController.from_client = false
            destinationViewController.tellerID = self.tellerId
        }
    }
    
}
