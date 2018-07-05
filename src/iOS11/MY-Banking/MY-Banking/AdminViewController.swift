//
//  AdminViewController.swift
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

internal class AdminViewController: UIViewController, GetAdminsDelegate, GetTellersDelegate, AllTransactionsDelegate, PendingClientsDelegate {
    var adminId: Int?
    var get_admins_handler: GetAdminsHandler?
    var get_tellers_handler: GetTellersHandler?
    var all_transactions_handler: AllTransactionsHandler?
    var pending_clients_handler: PendingClientstHandler?
    var received_admins: [Admin]?
    var received_tellers: [Teller]?
    var received_transactions: [Transaction]?
    var received_pending: [PendingClient]?
    var are_tellers: Bool?
    var are_transactions: Bool?

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
    }
    override func viewDidLoad() {
     //   self.hideKeyboard()
        get_admins_handler = GetAdminsHandler(delegate: self)
        get_tellers_handler = GetTellersHandler(delegate: self)
        all_transactions_handler = AllTransactionsHandler(delegate: self)
        pending_clients_handler = PendingClientstHandler(delegate: self)

        super.viewDidLoad()
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
    
    @IBAction func modifyAdmins(_ sender: UIButton) {
        self.pauseInteraction()
        get_admins_handler!.getAdmins()
    }
    @IBAction func modifyTellers(_ sender: UIButton) {
        self.pauseInteraction()
        get_tellers_handler!.getTellers()
    }
    @IBAction func viewTransactions(_ sender: UIButton) {
        pauseInteraction()
        all_transactions_handler!.allTransactions()
    }
    
    @IBAction func viewApplications(_ sender: Any) {
        pauseInteraction()
        pending_clients_handler!.pendingClients()
    }
    
    func adminsReceived(admins: [Admin]?) {
        self.resumeInteraction()
        if let admins_ = admins {
            received_admins = [Admin()]
            received_admins!.removeAll()
            for element in admins_ {
                if element.id! != adminId! {
                    received_admins!.append(element)
                }
            }
            if received_admins!.count > 0 {
                are_tellers = false
                AlertShower.showSweetAlertAndExecute(onCondition: true, title: "Success", message:  "\(received_admins!.count) Other Admin(s) Found", style: .success, buttonTitle: "OK", action: {(_ isOtherButton: Bool) -> Void in
                    self.performSegue(withIdentifier: "segue_employee", sender: nil)})
            } else {
                AlertShower.showErrorAlert(title: "Error", message: "No Admins Other Than You")
            }
        } else {
            AlertShower.showErrorAlert(title: "Error", message: "No Admins Received")
        }
    }
    func tellersReceived(tellers: [Teller]?) {
        self.resumeInteraction()
        received_tellers = tellers
        if let _ = tellers {
            are_tellers = true
            AlertShower.showSweetAlertAndExecute(onCondition: true, title: "Success", message: "\(received_tellers!.count) Teller(s) Found", style: .success, buttonTitle: "OK", action: {(_ isOtherButton: Bool) -> Void in
                self.performSegue(withIdentifier: "segue_employee", sender: nil)})
        } else {
            AlertShower.showErrorAlert(title: "Error", message: "No Tellers Received")
        }
    }
    func onTransactionsReceived(transactions: [Transaction]?) {
        self.received_transactions = transactions
        resumeInteraction()
        if let _ = transactions {
            are_transactions = true
            AlertShower.showSweetAlertAndExecute(onCondition: true, title: "Success", message: "\(received_transactions!.count) Transaction(s) Found", style: .success, buttonTitle: "OK", action: {(_ isOtherButton: Bool) -> Void in
                self.performSegue(withIdentifier: "admin_items_segue", sender: nil)})
        } else {
            AlertShower.showErrorAlert(title: "Error", message: "No Transactions Received")
        }
    }
    func onPendingClientsReceived(pending_clients: [PendingClient]?) {
        self.received_pending = pending_clients
        resumeInteraction()
        if let _ = pending_clients {
            are_transactions = false
            AlertShower.showSweetAlertAndExecute(onCondition: true, title: "Success", message: "\(pending_clients!.count) Pending Clients(s) Found", style: .success, buttonTitle: "OK", action: {(_ isOtherButton: Bool) -> Void in
                self.performSegue(withIdentifier: "admin_items_segue", sender: nil)})
        } else {
            AlertShower.showErrorAlert(title: "Error", message: "No Pending Clients Received")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? EmployeeViewController {
            destinationViewController.are_tellers = self.are_tellers
            destinationViewController.received_tellers = self.received_tellers
            destinationViewController.received_admins = self.received_admins
            if are_tellers! {
                destinationViewController.title_to_view = "Tellers"
            } else {
                destinationViewController.title_to_view = "Admins"
            }
        }
        if let destinationViewController = segue.destination as? AdminItemsViewController {
            if self.are_transactions! {
                destinationViewController.title_to_view = "Transactions"
                destinationViewController.received_transactions = self.received_transactions
                //destinationViewController.received_applications = nil
            } else {
                destinationViewController.title_to_view = "Applications"
                destinationViewController.received_applications = self.received_pending
                destinationViewController.received_transactions = nil
            }
            destinationViewController.are_transactions = self.are_transactions
            destinationViewController.adminId = self.adminId
        }
    }
    
}

