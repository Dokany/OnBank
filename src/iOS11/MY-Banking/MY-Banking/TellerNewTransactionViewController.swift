//
//  TellerNewTransactionViewController.swift
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

class TellerNewTransactionViewController : UIViewController, TellerTransactionDelegate {
    var clientID: Int?
    var tellerID: Int?
    var account: Account?
    
    var teller_transaction_handler: TellerTransactionHandler?
    
    @IBOutlet weak var amount_tf: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    override func viewWillAppear(_ animated: Bool) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
      //  self.hideKeyboard()
        teller_transaction_handler = TellerTransactionHandler(delegate: self)
        spinner.isHidden = true
        
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
        amount_tf.text = ""
        if result {
            AlertShower.showSuccessAlert(title: "Success", message: "Transaction Successful")
        } else {
            AlertShower.showErrorAlert(title: "Error", message: "Transaction Failed")
        }
    }
    
    @IBAction func deposit(_ sender: UIButton) {
        if let a = amount_tf.text {
            if a.count > 0 {
                if let _ = Double(a) {
                    pauseInteraction()
                    teller_transaction_handler?.performTransaction(tellerId: tellerID!, acctno: account!.number!, amount: a, is_deposit: true)
                } else {
                    AlertShower.showErrorAlert(title: "Invalid Information", message: "Invalid amount field")
                }
                
            } else {
                AlertShower.showErrorAlert(title: "Incomplete Information", message: "Empty amount field")
            }
        }
    }
    @IBAction func withdraw(_ sender: UIButton) {
        if let a = amount_tf.text {
            if a.count > 0 {
                if let _ = Double(a) {
                    pauseInteraction()
                    teller_transaction_handler?.performTransaction(tellerId: tellerID!, acctno: account!.number!, amount: a, is_deposit: false)
                } else {
                    AlertShower.showErrorAlert(title: "Invalid Information", message: "Invalid amount field")
                }
                
            } else {
                AlertShower.showErrorAlert(title: "Incomplete Information", message: "Empty amount field")
            }
        }
    }
    
    func onTransactionPerformed(result: Bool) {
        amount_tf.text = ""
        resumeInteraction()
        if result {
            AlertShower.showSuccessAlert(title: "Success", message: "Transaction Successful")
        } else {
            AlertShower.showErrorAlert(title: "Error", message: "Transaction Not Successful")
        }
    }
    
    
}
