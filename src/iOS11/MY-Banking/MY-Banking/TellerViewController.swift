//
//  TellerViewController.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/3/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

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
    
    override func viewWillAppear(_ animated: Bool) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
    @IBAction func newCurrentAccount(_ sender: UIButton) {
        if let id = clientId_tf?.text {
            if let clientId = Int(id) {
                self.pauseInteraction()
                add_account_handler!.addAccount(clientId: clientId, type: .Current)
            } else {
                AlertShower.showErrorAlert(title: "Error", message: "Incorrect Client Id")
            }
        } else {
            AlertShower.showErrorAlert(title: "Error", message: "Incorrect Client Id")
        }
    }
    @IBAction func newSavingsAccount(_ sender: UIButton) {
        if let id = clientId_tf?.text {
            if let clientId = Int(id) {
                self.pauseInteraction()
                add_account_handler!.addAccount(clientId: clientId, type: .Savings)
            } else {
                AlertShower.showErrorAlert(title: "Error", message: "Incorrect Client Id")
            }
        } else {
            AlertShower.showErrorAlert(title: "Error", message: "Incorrect Client Id")
        }
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
                                        if nin.count > 0 && e.count > 0 && f.count > 0 && l.count > 0 && h.count > 0 && u.count > 0 && p.count > 0 {
                                            if a.count > 0 {
                                                pauseInteraction()
                                                add_client_handler?.addClient(tellerId: tellerId!, NIN: nin, username: u, password: p, email: e, phone: h, first_name: f, last_name: l, address: address_te.text)
                                                return;
                                            } else {
                                                pauseInteraction()
                                                add_client_handler?.addClient(tellerId: tellerId!, NIN: nin, username: u, password: p, email: e, phone: h, first_name: f, last_name: l, address: nil)
                                                return;
                                            }
                                        }
                                    } else {
                                        pauseInteraction()
                                        add_client_handler?.addClient(tellerId: tellerId!, NIN: nin, username: u, password: p, email: e, phone: h, first_name: f, last_name: l, address: nil)
                                        return;
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
    
    func onAccountAdded(result: Bool) {
        clientId = Int(self.clientId_tf.text!)
        clientId_tf.text = ""
        resumeInteraction()
        if result {
            AlertShower.showSuccessAlert(title: "Success", message: "Account Added")
        } else {
            AlertShower.showErrorAlert(title: "Error", message: "Account Not Added")
        }
    }
    func onClientAdded(result: Bool) {
        nationalId_tf.text = ""
        email_tf.text = ""
        firstName_tf.text = ""
        lastName_tf.text = ""
        phone_tf.text = ""
        username_tf.text = ""
        password_tf.text = ""
        address_te.text = ""
        
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
