//
//  TransactionViewController.swift
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

internal class TransactionViewController: UIViewController {
    var transaction: Transaction?
    
    @IBOutlet weak var id_label: UILabel!
    @IBOutlet weak var acct_label: UILabel!
    @IBOutlet weak var data_label: UILabel!
    @IBOutlet weak var amount_label: UILabel!
    @IBOutlet weak var currency_label: UILabel!
    @IBOutlet weak var teller_label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  self.hideKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let n = transaction!.number {
            id_label.text = String(n)
        }
        if let t = transaction!.acctno {
            acct_label.text = String(t)
        }
        if let r = transaction!.teller {
            teller_label.text = String(r)
        }
        data_label.text = transaction!.date
        amount_label.text = transaction!.amount
        currency_label.text = transaction!.currency
    }
}
