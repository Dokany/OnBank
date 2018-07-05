//
//  AccountsViewController.swift
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

internal class AccountsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var clientID: Int?
    var tellerID: Int?
    var accounts: [Account]?
    var sending_account: Account?
    var from_client: Bool?
        
    @IBOutlet weak var accounts_table: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
       // accounts_table.reloadData()
        accounts_table.allowsMultipleSelection = true
        accounts_table.allowsSelectionDuringEditing = true
        accounts_table.allowsMultipleSelectionDuringEditing = true
        
        accounts_table.allowsSelection = true
        accounts_table.delegate = self
        accounts_table.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  self.hideKeyboard()
      
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        LogCat.printError(tag: "AccountsViewController", message: "Getting rows count")
        return accounts!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        LogCat.printError(tag: "AccountsViewController", message: "Getting row info")
        let cell: UITableViewCell! = self.accounts_table
            .dequeueReusableCell(withIdentifier: "cell") as UITableViewCell?
        
        cell.textLabel!.text = "\(self.accounts![indexPath.row].number!)"
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        LogCat.printError(tag: "AccountsViewController", message: "Row selected")
        self.sending_account = self.accounts?[indexPath.row]
        performSegue(withIdentifier: "client_account_segue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        LogCat.printError(tag: "AccountsViewController", message: "Preparing segue")
        if let destinationViewController = segue.destination as? AccountViewController {
            LogCat.printError(tag: "AccountsViewController", message: "Performing segue")
            destinationViewController.clientID = self.clientID
            destinationViewController.account = self.sending_account
            destinationViewController.from_client = self.from_client
            destinationViewController.tellerID = self.tellerID
        }
    }
    
}
