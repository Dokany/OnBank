//
//  LogInHandler.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/1/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation

class LogInHandler {
    let delegate : LogInDelegate
    
    init(delegate : LogInDelegate) {
        self.delegate = delegate
    }
    
    /**
     This method is called to attempt login
     */
    func logIn (username: String, password: String){
        self.delegate.userDidAttemptLogIn(result: LogInResult.Teller, id: 17)
        return;
        /*
        let API_login = API_LogIn()
        API_login.request(username: username, password: password, completionHandler: { data, response, error in
            if error == nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [.allowFragments]) as? [String: AnyObject]
                    if let dict = json {
                        if let type = dict[API_LogIn.type] as? String {
                            var login_result : LogInResult
                            if type == API_LogIn.type_admin {
                                login_result = LogInResult.Admin
                            } else if type == API_LogIn.type_client {
                                self.notifyClientLogIn(dict: dict)
                                return
                            } else if type == API_LogIn.type_teller {
                                login_result = LogInResult.Teller
                            } else {
                                login_result = LogInResult.UnknownCredentials
                                self.delegate.userDidAttemptLogIn(result: .UnknownCredentials, id: nil)
                            }
                        } else {
                            LogCat.printError(tag: "LogIn", message: "Unable to find value for \(API_LogIn.type)")
                            self.delegate.userDidAttemptLogIn(result: .ConnectionError, id: nil)
                        }
                    } else {
                        LogCat.printError(tag: "LogIn", message: "Unable to cast result as json")
                        self.delegate.userDidAttemptLogIn(result: .ConnectionError, id: nil)
                    }
                } catch _ {
                    LogCat.printError(tag: "LogIn", message: "Unkown error while reading returned result")
                    self.delegate.userDidAttemptLogIn(result: .ConnectionError, id: nil)
                }
            } else {
                LogCat.printError(tag: "LogIn", message: error!.localizedDescription)
                self.delegate.userDidAttemptLogIn(result: .ConnectionError, id: nil)
            }
            
        })
        
         */
    }
    
    func notifyClientLogIn(dict: [String: AnyObject]) {
        self.delegate.userDidAttemptLogIn(result: LogInResult.Client, id: dict[API_LogIn.id] as? Int)
    }
}


