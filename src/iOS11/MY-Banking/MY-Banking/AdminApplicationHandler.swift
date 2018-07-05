//
//  AdminApplicationHandler.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/5/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation

class AdminApplicationHandler {
    private let delegate : AdminApplicationDelegate
    
    init(delegate : AdminApplicationDelegate) {
        self.delegate = delegate
    }
    
    func viewPending(nin: String){
        //buildHardCodedApplicationAndNotifyClient(nin: nin)
        //return;
        
        let Api_adminApplication = API_AdminApplication()
        Api_adminApplication.requestApplication(nin: nin, completionHandler: { data, response, error in
            LogCat.printError(tag: "ViewPending", message: String(data: data!, encoding: String.Encoding.utf8)!)
            if error == nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [.allowFragments]) as? [String: AnyObject]
                    if let dict = json {
                        self.buildApplicationAndNotifyClient(nin: nin, element: dict)
                    } else {
                        LogCat.printError(tag: "ViewPending", message: "Unable to cast result as json")
                        self.delegate.onApplicationReceived(application: nil)
                    }
                } catch _ {
                    LogCat.printError(tag: "ViewPending", message: "Unkown error while reading returned result")
                    self.delegate.onApplicationReceived(application: nil)
                }
            } else {
                LogCat.printError(tag: "ViewPending", message: error!.localizedDescription)
                self.delegate.onApplicationReceived(application: nil)
            }
        })
        
    }
    
    func viewOwner(nin: String){
       // self.delegate.onOwnerInforReceived(name: "Mohamed T")
       // return;
        
        let Api_adminApplication = API_AdminApplication()
        Api_adminApplication.requestOwner(nin: nin, completionHandler: { data, response, error in
            LogCat.printError(tag: "ViewOwner", message: String(data: data!, encoding: String.Encoding.utf8)!)
            if error == nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [.allowFragments]) as? [String: AnyObject]
                    if let dict = json {
                        self.delegate.onOwnerInforReceived(name: dict[API_AdminApplication.name] as? String)
                    } else {
                        LogCat.printError(tag: "ViewOwner", message: "Unable to cast result as json")
                        self.delegate.onOwnerInforReceived(name: nil)
                    }
                } catch _ {
                    LogCat.printError(tag: "ViewOwner", message: "Unkown error while reading returned result")
                    self.delegate.onOwnerInforReceived(name: nil)
                }
            } else {
                LogCat.printError(tag: "ViewOwner", message: error!.localizedDescription)
                self.delegate.onOwnerInforReceived(name: nil)
            }
        })
        
    }
    
    private func buildApplicationAndNotifyClient(nin: String, element: [String: AnyObject]) {
        var application: ClientApplication? = nil
        if let username = element[API_AdminApplication.username] as? String {
            if let address = element[API_AdminApplication.address] as? String {
                if let email = element[API_AdminApplication.email] as? String {
                    if let name = element[API_AdminApplication.email] as? String {
                        if let phone = element[API_AdminApplication.email] as? String {
                            application = ClientApplication(NIN: nin, name: name, f_name: nil, l_name: nil, username: username, phone: phone, email: email, address: address)
                        }
                    }
                }
            }
        }
        
        self.delegate.onApplicationReceived(application: application)
    }
    
    
    private func buildHardCodedApplicationAndNotifyClient(nin: String) {
        let application = ClientApplication(NIN: nin, name: "Mohamed T", f_name: nil, l_name: nil, username: "mohamed_95", phone: "01231230123", email: "mohamed@auc.edu", address: "Virtual Address")
        
        self.delegate.onApplicationReceived(application: application)
    }
    
    
}
