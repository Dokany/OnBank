//
//  LoginViewController.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/1/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import UIKit

internal class LoginViewController: UIViewController, LogInDelegate, GetClientInfoDelegate {
    
    var login_handler : LogInHandler?
    var id: Int?
    var get_client_info_handler : GetClientInfoHandler?
    var client_data : ClientData?
    var password: String?
    
    @IBOutlet weak var tf_username: UITextField!
    @IBOutlet weak var tf_password: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.isHidden = true
        login_handler = LogInHandler(delegate: self)
        get_client_info_handler = GetClientInfoHandler(delegate: self)
        tf_username.backgroundColor = .white
        tf_password.backgroundColor = .white
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
    
    @IBAction func logInClicked(_ sender: UIButton) {
        if let username = tf_username.text {
            if username.count > 0 {
                if let password = tf_password.text {
                    if password.count > 0 {
                        pauseInteraction()
                        login_handler!.logIn(username: username, password: password)
                        
                    } else {
                        AlertShower.showErrorAlert(title: "Incomplete Information", message: "Please enter a valid password")
                    }
                }
            } else {
                AlertShower.showErrorAlert(title: "Incomplete Information", message: "Please enter a valid username")
            }
        }
        
    }
    
    func userDidAttemptLogIn(result: LogInResult, id: Int?) {
        resumeInteraction()
        self.id = id
        let username = tf_username.text!
        self.password = tf_password.text
        tf_password.text = ""
        tf_username.text = ""
        switch result {
            case LogInResult.UnknownCredentials:
                AlertShower.showErrorAlert(title: "Error", message: "Incorrect credentials")
                break
            case LogInResult.ConnectionError:
                AlertShower.showErrorAlert(title: "Error", message: "Connection error")
                break
            case LogInResult.Client:
                AlertShower.showSweetAlertAndExecute(onCondition: true, title: "Success", message: "Opening client portal", style: .success, buttonTitle: "Ok", action: {(_ isOtherButton: Bool) -> Void in
                        self.get_client_info_handler!.getClientInfo(username: username)
                })
                break
            case LogInResult.Teller:
                AlertShower.showSweetAlertAndExecute(onCondition: true, title: "Success", message: "Opening teller portal", style: .success, buttonTitle: "Ok", action: {(_ isOtherButton: Bool) -> Void in
                    self.performSegue(withIdentifier: "segue_teller", sender: nil)
                })
                break
            case LogInResult.Admin:
                AlertShower.showSuccessAlert(title: "Success", message: "Opening admin portal")
                break
        }
    }
    
    func clientDataRetrieved(data: ClientData?) {
        if data == nil {
            AlertShower.showErrorAlert(title: "Error", message: "No client info found")
            return;
        }
        self.client_data = data!
        self.client_data!.clientId = self.id
        self.client_data!.password = self.password
        //LogCat.printError(tag: "LoginViewController", message: "\(self.client_data)")
        performSegue(withIdentifier: "segue_client", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? ClientHomeViewController {
            destinationViewController.client_data = self.client_data
        }
        if let destinationViewController = segue.destination as? TellerViewController {
            destinationViewController.tellerId = self.id
        }
    }
    
}
