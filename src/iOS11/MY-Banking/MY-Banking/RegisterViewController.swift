//
//  RegisterViewController.swift
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

internal class RegisterViewController: UIViewController, AddClientDelegate {
    var add_client_handler: AddClientHandler?
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var nin_tf: UITextField!
    @IBOutlet weak var email_tf: UITextField!
    @IBOutlet weak var fname_tf: UITextField!
    @IBOutlet weak var lname_tf: UITextField!
    @IBOutlet weak var phone_tf: UITextField!
    @IBOutlet weak var username_tf: UITextField!
    @IBOutlet weak var password_tf: UITextField!
    @IBOutlet weak var address_te: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    //    self.hideKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        add_client_handler = AddClientHandler(delegate: self)
        self.spinner.isHidden = true
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
    
    @IBAction func submit(_ sender: UIButton) {
        if let nin = nin_tf.text {
            if let e = email_tf.text {
                if let f = fname_tf.text {
                    if let l = lname_tf.text {
                        if let h = phone_tf.text {
                            if let u = username_tf.text {
                                if let p = password_tf.text {
                                    if let a = address_te.text {
                                        if nin.count > 0 && e.count > 0 && f.count > 0 && l.count > 0 && h.count > 0 && u.count > 0 && p.count > 0 && a.count > 0 {
                                            pauseInteraction()
                                            add_client_handler?.addClient(tellerId: nil, NIN: nin, username: u, password: p, email: e, phone: h, first_name: f, last_name: l, address: a)
                                            return;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        AlertShower.showErrorAlert(title: "Error", message: "Invalid Form")
    }
    
    func onClientAdded(result: Bool) {
        resumeInteraction()
        if result {
            AlertShower.showSweetAlertAndExecute(onCondition: true, title: "Success", message: "Form Submitted", style: .success, buttonTitle: "OK", action: {(_ isOtherButton: Bool) -> Void in
                _ = self.navigationController?.popViewController(animated: true)
            })
        } else {
            AlertShower.showSweetAlertAndExecute(onCondition: true, title: "Error", message: "Error submitting form", style: .error, buttonTitle: "OK", action: {(_ isOtherButton: Bool) -> Void in
                _ = self.navigationController?.popViewController(animated: true)
            })
        }
    }
}

