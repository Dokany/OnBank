//
//  AccountViewController.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/2/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import UIKit

internal class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var clientID: Int?
    var tellerID: Int?
    var account: Account?
    var transactions: [Transaction]?
    var from_client: Bool?
    
    @IBOutlet weak var transactions_table: UITableView!
    @IBOutlet weak var currency_label: UILabel!
    @IBOutlet weak var balance_label: UILabel!
    @IBOutlet weak var account_type_label: UILabel!
    @IBOutlet weak var account_number_label: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        transactions_table.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        transactions_table.delegate = self
        transactions_table.dataSource = self
        account_number_label.text = "Account Number: " + "\(account!.number!)"
        account_type_label.text! = "Type: " + account!.acc_type!
        balance_label.text! = "Balance: " + String(account!.balance!)
        currency_label.text! = account!.curr!
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if transactions == nil {
            return 0
        } else {
            return transactions!.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell! = self.transactions_table
            .dequeueReusableCell(withIdentifier: "cell_tran") as UITableViewCell?
        
        cell.textLabel!.text = String(self.transactions![indexPath.row].amount!)
        cell.detailTextLabel!.text = String(self.transactions![indexPath.row].number!) + " / " + self.transactions![indexPath.row].date!
        
        return cell
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
        
    }
    
   
    
}
