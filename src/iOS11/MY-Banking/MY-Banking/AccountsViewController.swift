//
//  AccountsViewController.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/2/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import UIKit

internal class AccountsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var clientID: Int?
    var tellerID: Int?
    var accounts: [Account]?
    var sending_account: Account?
    var from_client: Bool?
        
    @IBOutlet weak var accounts_table: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        accounts_table.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accounts_table.delegate = self
        accounts_table.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
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
        self.sending_account = self.accounts?[indexPath.row]
        performSegue(withIdentifier: "client_account_segue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? AccountViewController {
            destinationViewController.clientID = self.clientID
            destinationViewController.account = self.sending_account
            destinationViewController.from_client = self.from_client
            destinationViewController.tellerID = self.tellerID
        }
    }
    
}
