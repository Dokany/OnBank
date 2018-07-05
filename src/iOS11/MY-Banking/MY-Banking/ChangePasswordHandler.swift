//
//  ChangePasswordHandler.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/1/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation

class ChangePasswordHandler {
    let delegate : ChangePasswordDelegate
    
    init(delegate : ChangePasswordDelegate) {
        self.delegate = delegate
    }
    
    /**
     This method is called to attempt login
     */
    func changePassword (username: String, password: String, type: String){
       // self.delegate.userDidAttemptChangePassword(result: true)
       // return;
        let Api_changePassword = API_ChangePassword()
        Api_changePassword.request(username: username, password: password, type: type, completionHandler: { data, response, error in
        if error == nil {
            do {
            let json = try JSONSerialization.jsonObject(with: data!, options: [.allowFragments]) as? [String: AnyObject]
            if let dict = json {
                if let success = dict[API_ChangePassword.success] as? Int {
                    var result: Bool
                    if success == 0 {
                        result = false
                    } else {
                        result = true
                    }
                    self.delegate.userDidAttemptChangePassword(result: result)
                } else {
                    LogCat.printError(tag: "ChangePassword", message: "Unable to find value for \(API_ChangePassword.success)")
                }
             } else {
             LogCat.printError(tag: "ChangePassword", message: "Unable to cast result as json")
             }
             } catch _ {
             LogCat.printError(tag: "ChangePassword", message: "Unkown error while reading returned result")
             }
             } else {
             LogCat.printError(tag: "ChangePassword", message: error!.localizedDescription)
             }
             })
        
    }
}



