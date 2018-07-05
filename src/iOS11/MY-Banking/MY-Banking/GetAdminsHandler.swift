//
//  GetAdminsHandler.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/4/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation

class GetAdminsHandler {
    let delegate : GetAdminsDelegate
    
    init(delegate : GetAdminsDelegate) {
        self.delegate = delegate
    }
    
    func getAdmins (){
        let Api_getAdmins = API_GetAdmins()
        Api_getAdmins.request(completionHandler: { data, response, error in
            LogCat.printError(tag: "GetAdmins", message: "\(String(data: data!, encoding: String.Encoding.utf8)!)")
            if error == nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [.allowFragments]) as? [String: AnyObject]
                    if let dict = json {
                        self.buildAdminsAndNotifyDelegate(dict: dict)
                    } else {
                        LogCat.printError(tag: "GetAdmins", message: "Unable to cast result as json")
                    }
                } catch _ {
                    LogCat.printError(tag: "GetAdmins", message: "Unkown error while reading returned result")
                }
            } else {
                LogCat.printError(tag: "GetAdmins", message: error!.localizedDescription)
            }
        })
        
    }
    
    private func buildAdminsAndNotifyDelegate(dict: [String: AnyObject]) {
        if let number = dict[API_GetAdmins.number] as? Int {
            var admins = [Admin()]
            admins.removeAll()
            if number < 1 {
                self.delegate.adminsReceived(admins: nil)
                return
            } else {
                for i in 0...(number-1) {
                    if let element = dict[String(i)] as? [String: AnyObject] {
                        if let admin = self.buildAdmin(element: element) {
                            admins.append(admin)
                        } else {
                            LogCat.printError(tag: "GetAdmins", message: "Unable to unpack admin")
                        }
                    } else {
                        LogCat.printError(tag: "GetAdmins", message: "Unable to unpack admin \(i)")
                    }
                }
            }
            
            if admins.count > 0 {
                self.delegate.adminsReceived(admins: admins)
            } else {
                self.delegate.adminsReceived(admins: nil)
            }
            
        } else {
            LogCat.printError(tag: "GetAdmins", message: "Unable to retrieve number of admins")
            self.delegate.adminsReceived(admins: nil)
        }
    }
    
    private func buildAdmin(element: [String: AnyObject]) -> Admin? {
        var admin: Admin? = nil
        
        if let id = element[API_GetAdmins.id] as? Int {
            if let username = element[API_GetAdmins.username] as? String {
                admin = Admin()
                admin?.id = id
                admin?.username = username
            }
        }
        return admin
    }
}


