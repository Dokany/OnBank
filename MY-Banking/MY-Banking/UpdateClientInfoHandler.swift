//
//  UpdateClientInfoHandler.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/2/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation

class UpdateClientInfoHandler {
    let delegate : UpdateClientInfoDelegate
    
    init(delegate : UpdateClientInfoDelegate) {
        self.delegate = delegate
    }

    func updateInfo (username: String, phone: String, email: String, address: String){
       // self.delegate.clientDidAttemptChangeInfo(result: true)
        //return;
        
        let Api_updateclientinfo = API_UpdateClientInfo()
        Api_updateclientinfo.request(username: username, phone: phone, email: email, address: address, completionHandler: { data, response, error in
            if error == nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [.allowFragments]) as? [String: AnyObject]
                    if let dict = json {
                        if let success = dict[API_UpdateClientInfo.success] as? Int {
                            var result: Bool
                            if success == 0 {
                                result = false
                            } else {
                                result = true
                            }
                            self.delegate.clientDidAttemptChangeInfo(result: result)
                        } else {
                            LogCat.printError(tag: "UpdateClientInfo", message: "Unable to find value for \(API_UpdateClientInfo.success)")
                        }
                    } else {
                        LogCat.printError(tag: "UpdateClientInfo", message: "Unable to cast result as json")
                    }
                } catch _ {
                    LogCat.printError(tag: "UpdateClientInfo", message: "Unkown error while reading returned result")
                }
            } else {
                LogCat.printError(tag: "UpdateClientInfo", message: error!.localizedDescription)
            }
        })
    }
        
}
