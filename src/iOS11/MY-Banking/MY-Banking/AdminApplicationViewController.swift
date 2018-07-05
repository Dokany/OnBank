//
//  AdminApplicationViewController.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/4/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation
import UIKit

internal class AdminApplicationViewController: UIViewController, ApproveApplicationDelegate {
    var application: ClientApplication?
    var owner_name: String?
    var adminId: Int?
    
    @IBOutlet weak var nin_tf: UILabel!
    @IBOutlet weak var name_tf: UILabel!
    @IBOutlet weak var phone_tf: UILabel!
    @IBOutlet weak var email_tf: UILabel!
    @IBOutlet weak var username_tf: UILabel!
    @IBOutlet weak var address_tf: UILabel!
    @IBOutlet weak var owner_tf: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var approve_application_handler: ApproveApplicationHandler?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        approve_application_handler = ApproveApplicationHandler(delegate: self)
        nin_tf.text = application!.NIN
        name_tf.text = application!.name
        phone_tf.text = application!.phone
        email_tf.text = application!.email
        username_tf.text = application!.username
        address_tf.text = application!.address
        owner_tf.text = owner_name
        spinner.isHidden = true
    }
    

    @IBAction func approve(_ sender: UIButton) {
        if let owner = owner_tf.text {
            if owner == application!.name! {
                approve_application_handler?.approveApplication(NIN: application!.NIN!, adminId: adminId!)
            } else {
                AlertShower.showSweetAlertAndExecute(onCondition: true, title: "Error", message: "Names don't match", style: .error, buttonTitle: "OK", action: {(_ isOtherButton: Bool) -> Void in
                    _ = self.navigationController?.popViewController(animated: true)
                })
            }
        } else {
            AlertShower.showSweetAlertAndExecute(onCondition: true, title: "Error", message: "No owner exists", style: .error, buttonTitle: "OK", action: {(_ isOtherButton: Bool) -> Void in
                _ = self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    func isApplication(approved: Bool) {
        if approved {
            AlertShower.showSweetAlertAndExecute(onCondition: true, title: "Success", message: "Application Approved", style: .success, buttonTitle: "OK", action: {(_ isOtherButton: Bool) -> Void in
                _ = self.navigationController?.popViewController(animated: true)
            })
        } else {
            AlertShower.showSweetAlertAndExecute(onCondition: true, title: "Error", message: "Application Not Approved", style: .error, buttonTitle: "OK", action: {(_ isOtherButton: Bool) -> Void in
                _ = self.navigationController?.popViewController(animated: true)
            })
        }
    }
}
