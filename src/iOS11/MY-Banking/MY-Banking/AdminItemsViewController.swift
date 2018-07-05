//
//  AdminItemsViewController.swift
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

internal class AdminItemsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AdminApplicationDelegate {
    var admin_application_handler: AdminApplicationHandler?
    
    var received_transactions: [Transaction]?
    var chosen_application: ClientApplication?
    var owner_name: String?
    var chosen_index: Int?
    var received_applications: [PendingClient]?
    var are_transactions: Bool?
    var title_to_view: String?
    var adminId: Int?
    
    @IBOutlet weak var items_table: UITableView!
    @IBOutlet weak var title_label: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!


    override func viewWillAppear(_ animated: Bool) {
        self.title_label.text = title_to_view
        admin_application_handler = AdminApplicationHandler(delegate: self)
        items_table.reloadData()
        items_table.delegate = self
        items_table.dataSource = self
        spinner.isHidden = true
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     //   self.hideKeyboard()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if are_transactions! {
            return received_transactions!.count
        } else {
            return received_applications!.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell! = self.items_table
            .dequeueReusableCell(withIdentifier: "admin_item_cell") as UITableViewCell?
        if are_transactions! {
            cell.textLabel!.text = "\(self.received_transactions![indexPath.row].number!)"
        } else {
            cell.textLabel!.text = "\(self.received_applications![indexPath.row].NIN!)"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosen_index = indexPath.row
        if are_transactions! {
            performSegue(withIdentifier: "open_transaction_segue", sender: nil)
        } else {
            self.pauseInteraction()
            admin_application_handler?.viewPending(nin: self.received_applications![chosen_index!].NIN!)
        }
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
    
    func onApplicationReceived(application: ClientApplication?) {
        self.chosen_application = application
        self.resumeInteraction()
        if let _ = application {
            AlertShower.showSweetAlertAndExecute(onCondition: true, title: "Success", message: "Details of Application Found", style: .success, buttonTitle: "OK", action: {(_ isOtherButton: Bool) -> Void in
                self.pauseInteraction()
                self.admin_application_handler?.viewOwner(nin: self.received_applications![self.chosen_index!].NIN!)
            })
                
        } else {
            AlertShower.showErrorAlert(title: "Error", message: "Details of Application Not Found")
        }
    }
    
    func onOwnerInforReceived(name: String?) {
        self.owner_name = name
        self.resumeInteraction()
        if let _ = name {
            AlertShower.showSweetAlertAndExecute(onCondition: true, title: "Success", message: "Details of Owner Found", style: .success, buttonTitle: "OK", action: {(_ isOtherButton: Bool) -> Void in
                self.performSegue(withIdentifier: "admin_application_segue", sender: nil)
            })
            
        } else {
            AlertShower.showErrorAlert(title: "Error", message: "Details of Owner Not Found")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? TransactionViewController {
            destinationViewController.transaction = received_transactions![chosen_index!]
        }
        if let destinationViewController = segue.destination as? AdminApplicationViewController {
            destinationViewController.application = self.chosen_application
            destinationViewController.owner_name = self.owner_name
            destinationViewController.adminId = self.adminId
        }
    }

}

