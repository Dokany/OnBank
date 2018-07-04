//
//  ClientNewTransactionViewController.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/3/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation
import UIKit

internal class ClientNewTransactionViewController: UIViewController, PerformTransactionDelegate{
    var clientID: Int?
    var account: Account?
    var perform_transaction_handler: PerformTransactionHandler?
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var receiving_account_tf: UITextField!
    @IBOutlet weak var amount_tf: UITextField!
    override func viewWillAppear(_ animated: Bool) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.isHidden = true
        perform_transaction_handler = PerformTransactionHandler(delegate: self)
        
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
    
    func transactionResult(result: Bool) {
        resumeInteraction()
        receiving_account_tf.text = ""
        amount_tf.text = ""
        if result {
            AlertShower.showSuccessAlert(title: "Success", message: "Transaction Successful")
        } else {
            AlertShower.showErrorAlert(title: "Error", message: "Transaction Failed")
        }
    }
    
   
    @IBAction func performTransactionPressed(_ sender: UIButton) {
        if let r = receiving_account_tf.text {
            if r.count > 0 {
                if let a = amount_tf.text {
                    if a.count > 0 {
                        if let _ = Double(a) {
                            pauseInteraction()
                            perform_transaction_handler!.performTransaction(clientId: clientID!, sending_account: self.account!.number!, receiving_account: Int(r)!, amount: a)
                        } else {
                            AlertShower.showErrorAlert(title: "Invalid Information", message: "Invalid amount field")
                        }
                       
                    } else {
                        AlertShower.showErrorAlert(title: "Incomplete Information", message: "Empty amount field")
                    }
                }
            } else {
                AlertShower.showErrorAlert(title: "Incomplete Information", message: "Empty receiving account field")
            }
        }
    }
    
    
    
    
    
}
