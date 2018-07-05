//
//  EmployeeViewController.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/4/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation
import UIKit

internal class EmployeeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DeleteEmployeeDelegate, ChangePasswordDelegate, AddEmployeeDelegate {
    
   
    var received_admins: [Admin]?
    var received_tellers: [Teller]?
    var are_tellers: Bool?
    var title_to_view: String?
    
    @IBOutlet weak var employees_tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var title_label: UILabel!
    @IBOutlet weak var username_tf: UITextField!
    @IBOutlet weak var password_tf: UITextField!
    @IBOutlet weak var new_password_tf: UITextField!
    
    var delete_employee_handler: DeleteEmployeeHandler?
    var change_password_handler: ChangePasswordHandler?
    var add_employee_handler: AddEmployeeHandler?
    
    override func viewWillAppear(_ animated: Bool) {
        title_label.text = title_to_view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.isHidden = true
        employees_tableView.delegate = self
        employees_tableView.dataSource = self
        delete_employee_handler = DeleteEmployeeHandler(delegate: self)
        change_password_handler = ChangePasswordHandler(delegate: self)
        add_employee_handler = AddEmployeeHandler(delegate: self)
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if are_tellers! {
            return received_tellers!.count
        } else {
            return received_admins!.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell! = self.employees_tableView
            .dequeueReusableCell(withIdentifier: "admin_person_cell") as UITableViewCell?
        if are_tellers! {
            cell.textLabel!.text = "\(self.received_tellers![indexPath.row].username!)"
            cell.detailTextLabel!.text = "\(self.received_tellers![indexPath.row].id!)"
        } else {
            cell.textLabel!.text = "\(self.received_admins![indexPath.row].username!)"
            cell.detailTextLabel!.text = "\(self.received_admins![indexPath.row].id!)"
        }
        
      return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AlertShower.showSweetAlert(onCondition: true, title: "Choose Action", message: nil, style: .none, buttonTitle: "Delete", otherButtonTitle: "Change Password", action: {(isOtherButton: Bool) -> Void in
            if !isOtherButton {
                if let p = self.new_password_tf.text {
                    if p.count > 0 {
                        self.pauseInteraction()
                        if self.are_tellers! {
                            self.change_password_handler!.changePassword(username: self.received_tellers![indexPath.row].username!, password: p, type: "teller")
                        } else {
                            self.change_password_handler!.changePassword(username: self.received_admins![indexPath.row].username!, password: p, type: "admin")
                        }
                    } else {
                        AlertShower.showErrorAlert(title: "Error", message: "New Password Field Missing")
                    }
                }
            } else {
                self.pauseInteraction()
                if self.are_tellers! {
                    self.delete_employee_handler!.deleteEmployee(username: self.received_tellers![indexPath.row].username!, type: "teller")
                } else {
                    self.delete_employee_handler!.deleteEmployee(username: self.received_admins![indexPath.row].username!, type: "admin")
                }
                
            }
        })
    }
    
    func onEmployeeDeleted(result: Bool) {
        resumeInteraction()
        if result {
            AlertShower.showSuccessAlert(title: "Success", message: "Employee Deleted")
        } else {
            AlertShower.showErrorAlert(title: "Error", message: "Employee Not Deleted")
        }
    }
    
    func userDidAttemptChangePassword(result: Bool) {
        resumeInteraction()
        if result {
            AlertShower.showSuccessAlert(title: "Success", message: "Password Changed")
        } else {
            AlertShower.showErrorAlert(title: "Error", message: "Password Not Changed")
        }
    }
    func onEmployeeAdded(result: Bool) {
        resumeInteraction()
        if result {
            AlertShower.showSuccessAlert(title: "Success", message: "Employee Added")
        } else {
            AlertShower.showErrorAlert(title: "Error", message: "Employee Not Added")
        }
    }
    
    @IBAction func createPressed(_ sender: UIButton) {
        LogCat.printError(tag: "AddEmployee", message: "A")

        if let u = username_tf.text {
            if let p = password_tf.text {
                if u.count > 0 && p.count > 0 {
                    LogCat.printError(tag: "AddEmployee", message: "B")

                    pauseInteraction()
                    if self.are_tellers! {
                        LogCat.printError(tag: "AddEmployee", message: "C+")
                        add_employee_handler?.addEmployee(username: u, password: p, type: "teller")
                        LogCat.printError(tag: "AddEmployee", message: "D+")
                    } else {
                        LogCat.printError(tag: "AddEmployee", message: "C")
                        add_employee_handler?.addEmployee(username: u, password: p, type: "admin")
                        LogCat.printError(tag: "AddEmployee", message: "D")
                    }
                    return;
                }
            }
        }
        
        AlertShower.showErrorAlert(title: "Error", message: "Invalid Form")
    }
    
    func clearTexts() {
        return;
        username_tf.text = ""
        password_tf.text = ""
        new_password_tf.text = ""
    }
    
}
