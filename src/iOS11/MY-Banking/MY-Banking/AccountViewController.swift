//
//  AccountViewController.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/2/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import UIKit

internal class AccountViewController: UIViewController, GetTransactionssDelegate{
    var clientID: Int?
    var tellerID: Int?
    var account: Account?
    var get_transactions_handler: GetTransactionsHandler?
    var transactions: [Transaction]?
    var from_client: Bool?
    
    @IBOutlet weak var currency_label: UILabel!
    @IBOutlet weak var balance_label: UILabel!
    @IBOutlet weak var account_type_label: UILabel!
    @IBOutlet weak var account_number_label: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        get_transactions_handler = GetTransactionsHandler(delegate: self)
        account_number_label.text = "Account Number: " + "\(account!.number!)"
        account_type_label.text! = "Type: " + account!.acc_type!
        balance_label.text! = "Balance: " + String(account!.balance!)
        currency_label.text! = "Currency: " + account!.curr!
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func pauseInteraction() {
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    func resumeInteraction() {
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    @IBAction func newTransactionPressed(_ sender: UIButton) {
        if self.from_client! {
            performSegue(withIdentifier: "client_new_transaction", sender: nil)
        } else {
            performSegue(withIdentifier: "teller_transaction", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? ClientNewTransactionViewController {
            destinationViewController.clientID = self.clientID
            destinationViewController.account = self.account
        }
        if let destinationViewController = segue.destination as? TellerNewTransactionViewController {
            destinationViewController.clientID = self.clientID
            destinationViewController.tellerID  = self.tellerID
            destinationViewController.account = self.account
        }
        if let destinationViewController = segue.destination as? AdminItemsViewController {
            destinationViewController.are_transactions = true
            destinationViewController.received_transactions = transactions
            destinationViewController.title_to_view = "Transactions"
        }
    }
    
    @IBAction func viewTransactions(_ sender: UIButton) {
        get_transactions_handler?.getTransactions(acctno: self.account!.number!)
    }
    
    func transactionsReceived(transactions: [Transaction]?) {
        self.transactions = transactions
        if transactions == nil {
            AlertShower.showErrorAlert(title: "Error", message: "No Transactions found")
        } else {
            enhanceTransactions()
            resumeInteraction()
            AlertShower.showSweetAlertAndExecute(onCondition: true, title: "Success", message: "\(transactions!.count) Transactions Found", style: .success, buttonTitle: "OK", action: {(_ isOtherButton: Bool) -> Void in
                self.performSegue(withIdentifier: "client_transactions_segue", sender: nil)
            })
        }
    }
    
    func enhanceTransactions() {
        for index in transactions!.indices {
            transactions![index].acctno = account!.number
            transactions![index].currency = account!.curr
        }
    }
    
}
