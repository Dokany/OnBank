//
//  LogInHandler.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/1/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation

class LogInHandler {
    private let delegate : LogInDelegate
    
    init(delegate : LogInDelegate) {
        self.delegate = delegate
    }
    
    /**
     This method is called to attempt login
     */
    func logIn (username: String, password: String){
       // self.delegate.userDidAttemptLogIn(result: LogInResult.Client, id: 2, must_change: true, type: "client")
       //return;
       // /*
        let API_login = API_LogIn()
        API_login.request(username: username, password: password, completionHandler: { data, response, error in
            if error == nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [.allowFragments]) as? [String: AnyObject]
                    if let dict = json {
                        var must_change = false
                        if let change = dict[API_LogIn.change] as? Int {
                            if change == 1 {
                                must_change = true
                            }
                        }
                        if let type = dict[API_LogIn.type] as? String {
                            if type == API_LogIn.type_admin {
                                self.delegate.userDidAttemptLogIn(result: LogInResult.Admin, id: dict[API_LogIn.id] as? Int, must_change: must_change, type: type)
                            } else if type == API_LogIn.type_client {
                                self.delegate.userDidAttemptLogIn(result: LogInResult.Client, id: dict[API_LogIn.id] as? Int, must_change: must_change, type: type)
                            } else if type == API_LogIn.type_teller {
                                self.delegate.userDidAttemptLogIn(result: LogInResult.Teller, id: dict[API_LogIn.id] as? Int, must_change: must_change, type: type)
                            } else {
                                self.delegate.userDidAttemptLogIn(result: LogInResult.UnknownCredentials, id: dict[API_LogIn.id] as? Int, must_change: false, type: type)
                            }
                            return
                        } else {
                            LogCat.printError(tag: "LogIn", message: "Unable to find value for \(API_LogIn.type)")
                            self.delegate.userDidAttemptLogIn(result: LogInResult.ConnectionError, id: nil, must_change: false, type: "none")
                        }
                    } else {
                        LogCat.printError(tag: "LogIn", message: "Unable to cast result as json")
                        self.delegate.userDidAttemptLogIn(result: LogInResult.ConnectionError, id: nil, must_change: false, type: "none")
                    }
                } catch _ {
                    LogCat.printError(tag: "LogIn", message: "Unkown error while reading returned result")
                    self.delegate.userDidAttemptLogIn(result: LogInResult.ConnectionError, id: nil, must_change: false, type: "none")
                }
            } else {
                LogCat.printError(tag: "LogIn", message: error!.localizedDescription)
                self.delegate.userDidAttemptLogIn(result: LogInResult.ConnectionError, id: nil, must_change: false, type: "none")
            }
            
        })
        
        // */
    }
    
    func forgotPassword(username: String) {
       // self.delegate.userDidResetPassword(result: true)
       // return;
        
        let API_login = API_LogIn()
        API_login.forgotPassword(username: username, completionHandler: { data, response, error in
            LogCat.printError(tag: "ForgotPassword", message: "\(String(data: data!, encoding: String.Encoding.utf8)!)")
            
            if error == nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [.allowFragments]) as? [String: AnyObject]
                    if let dict = json {
                        if let success = dict[API_PerformTransaction.success] as? Int {
                            var result: Bool
                            if success == 0 {
                                result = false
                            } else {
                                result = true
                            }
                            self.delegate.userDidResetPassword(result: result)
                        } else {
                            LogCat.printError(tag: "ForgotPassword", message: "Unable to find value for \(API_LogIn.success)")
                            self.delegate.userDidResetPassword(result: false)
                        }
                    } else {
                        LogCat.printError(tag: "ForgotPassword", message: "Unable to cast result as json")
                        self.delegate.userDidResetPassword(result: false)
                    }
                } catch _ {
                    LogCat.printError(tag: "ForgotPassword", message: "Unkown error while reading returned result")
                    self.delegate.userDidResetPassword(result: false)
                }
            } else {
                LogCat.printError(tag: "ForgotPassword", message: error!.localizedDescription)
                self.delegate.userDidResetPassword(result: false)
            }
        })
    }

}


