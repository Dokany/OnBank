//
//  AddClientHandler.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/4/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation

class AddClientHandler {
    let delegate : AddClientDelegate
    
    init(delegate : AddClientDelegate) {
        self.delegate = delegate
    }
    
    func addClient(tellerId: Int?, NIN: String, username: String, password: String, email: String, phone: String, first_name: String, last_name: String, address: String){
     // self.delegate.onClientAdded(result: true)
     // return;
        
        let Api_addClient = API_AddClient()
        Api_addClient.request(tellerId: tellerId, NIN: NIN, username: username, password: password, phone: phone, email: email, first_name: first_name, last_name: last_name, address: address, completionHandler: { data, response, error in
            LogCat.printError(tag: "AddClient", message: "\(String(data: data!, encoding: String.Encoding.utf8)!)")
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
                            self.delegate.onClientAdded(result: result)
                        } else {
                            LogCat.printError(tag: "AddClient", message: "Unable to find value for \(API_AddClient.success)")
                        }
                    } else {
                        LogCat.printError(tag: "AddClient", message: "Unable to cast result as json")
                    }
                } catch _ {
                    LogCat.printError(tag: "AddClient", message: "Unkown error while reading returned result")
                }
            } else {
                LogCat.printError(tag: "AddClient", message: error!.localizedDescription)
            }
            })
       
    }
    
}
