//
//  AddAccountHandler.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/4/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation

class AddAccountHandler {
    let delegate : AddAccountDelegate
    
    init(delegate : AddAccountDelegate) {
        self.delegate = delegate
    }
    
    func addAccount (clientId: Int, NIN: String, type: AccountType, currency: String){
       // self.delegate.onAccountAdded(result: true)
       // return;
        
        let Api_addAccount = API_AddAccount()
        Api_addAccount.request(clientId: clientId, NIN: NIN, type: type, currency: currency, completionHandler: { data, response, error in
            LogCat.printError(tag: "AddAccount", message: "\(String(data: data!, encoding: String.Encoding.utf8)!)")
            
            if error == nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [.allowFragments]) as? [String: AnyObject]
                    if let dict = json {
                        if let success = dict[API_AddAccount.success] as? Int {
                            var result: Bool
                            if success == 0 {
                                result = false
                            } else {
                                result = true
                            }
                            self.delegate.onAccountAdded(result: result)
                        } else {
                            LogCat.printError(tag: "AddAccount", message: "Unable to find value for \(API_AddAccount.success)")
                        }
                    } else {
                        LogCat.printError(tag: "AddAccount", message: "Unable to cast result as json")
                    }
                } catch _ {
                    LogCat.printError(tag: "AddAccount", message: "Unkown error while reading returned result")
                }
            } else {
                LogCat.printError(tag: "AddAccount", message: error!.localizedDescription)
            }
        })
    }
    
}
