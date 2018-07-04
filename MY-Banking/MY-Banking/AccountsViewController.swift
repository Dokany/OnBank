//
//  AccountsViewController.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/2/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import UIKit

internal class AccountsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GetTransactionssDelegate{
    var clientID: Int?
    var tellerID: Int?
    var accounts: [Account]?
    var sending_account: Account?
    var get_transactions_handler: GetTransactionsHandler?
    var transactions: [Transaction]?
    var from_client: Bool?
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var accounts_table: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        accounts_table.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accounts_table.delegate = self
        accounts_table.dataSource = self
        get_transactions_handler = GetTransactionsHandler(delegate: self)
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
    
    func transactionsReceived(transactions: [Transaction]?) {
        resumeInteraction()
        self.transactions = transactions
        var num: String
        if transactions == nil {num = "0"} else {num = String(self.transactions!.count)}
        AlertShower.showSweetAlertAndExecute(onCondition: true, title: "Success", message: "\(num) Transactions Found", style: .success, buttonTitle: "OK", action: {(_ isOtherButton: Bool) -> Void in
            self.performSegue(withIdentifier: "client_account_segue", sender: nil)
        })
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell! = self.accounts_table
            .dequeueReusableCell(withIdentifier: "cell") as UITableViewCell?
        
        cell.textLabel!.text = "\(self.accounts![indexPath.row].number!)"
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // AlertShower.showSuccessAlert(title: "Row Selected", message: String(indexPath.row))
        pauseInteraction()
        self.sending_account = self.accounts?[indexPath.row]
        get_transactions_handler?.getTransactions(acctno: self.accounts![indexPath.row].number!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? AccountViewController {
            destinationViewController.clientID = self.clientID
            destinationViewController.account = self.sending_account
            destinationViewController.transactions = self.transactions
            destinationViewController.from_client = self.from_client
            destinationViewController.tellerID = self.tellerID
        }
    }
    
}
