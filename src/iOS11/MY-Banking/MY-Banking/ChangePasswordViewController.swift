//
//  ChangePasswordViewController.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/5/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation
import UIKit

internal class ChangePAsswordViewController: UIViewController, ChangePasswordDelegate {
    var type: String?
    var username: String?
    var change_password_handler: ChangePasswordHandler?
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var new_password_tf: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.spinner.isHidden = true
        change_password_handler = ChangePasswordHandler(delegate: self)
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
    @IBAction func changePassword(_ sender: UIButton) {
        if let new_p = new_password_tf.text {
            if new_p.count > 0 {
                self.pauseInteraction()
                change_password_handler?.changePassword(username: username!, password: new_p, type: type!)
            } else {
                AlertShower.showErrorAlert(title: "Error", message: "Enter a Valid New Password")
            }
        } else {
            AlertShower.showErrorAlert(title: "Error", message: "Enter a Valid New Password")
        }
    }
    func userDidAttemptChangePassword(result: Bool) {
        resumeInteraction()
        if result {
            AlertShower.showSweetAlertAndExecute(onCondition: true, title: "Success", message: "Password Changed", style: .success, buttonTitle: "OK", action: {(_ isOtherButton: Bool) -> Void in
                _ = self.navigationController?.popViewController(animated: true)
            })
        } else {
            AlertShower.showSweetAlertAndExecute(onCondition: true, title: "Error", message: "Password Not Changed", style: .error, buttonTitle: "OK", action: {(_ isOtherButton: Bool) -> Void in
                _ = self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    
}
