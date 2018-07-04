//
//  GetClientInfoHandler.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/1/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation

class GetClientInfoHandler {
    var delegate : GetClientInfoDelegate?
    
    init(delegate : GetClientInfoDelegate) {
        self.delegate = delegate
    }
    
    /**
     This method is called to attempt to get client info
     */
    func getClientInfo (username: String){
        //self.delegate!.clientDataRetrieved(data: self.retrieveHardCodedInfo(username: username))
        //return;
       // /*
        let API_getclientinfo = API_GetClientInfo()
        API_getclientinfo.request(username: username, completionHandler: { data, response, error in
            //LogCat.printError(tag: "GetClientInfo", message: String(data: data!, encoding: String.Encoding.utf8)!)
            if error == nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [.allowFragments]) as? [String: AnyObject]
                    var client_data = ClientData()
                    if let dict = json {
                        client_data = self.retrieveInfo(username: username, dict: dict)
                        self.delegate!.clientDataRetrieved(data: client_data)
                    } else {
                        LogCat.printError(tag: "GetClientInfo", message: "Unable to cast result as json")
                        self.delegate!.clientDataRetrieved(data: nil)
                    }
                } catch _ {
                    LogCat.printError(tag: "GetClientInfo", message: "Unkown error while reading returned result")
                    self.delegate!.clientDataRetrieved(data: nil)
                }
            } else {
                LogCat.printError(tag: "GetClientInfo", message: error!.localizedDescription)
                self.delegate!.clientDataRetrieved(data: nil)
            }

        })
        // */
    }
    
    func retrieveInfo(username: String, dict: [String: AnyObject]) -> ClientData {
        var c_data: ClientData = ClientData()
        c_data.username = username
        
        if let nin = dict[API_GetClientInfo.NIN] as? String {
            c_data.NIN = nin
        } else {
            LogCat.printError(tag: "GetClientInfo", message: "Unable to find value for \(API_GetClientInfo.NIN)")
        }
        
        if let name = dict[API_GetClientInfo.name] as? String {
            c_data.name = name
        } else {
            LogCat.printError(tag: "GetClientInfo", message: "Unable to find value for \(API_GetClientInfo.name)")
        }
        
        if let phone = dict[API_GetClientInfo.phone] as? String {
            c_data.phone = phone
        } else {
            LogCat.printError(tag: "GetClientInfo", message: "Unable to find value for \(API_GetClientInfo.phone)")
        }
        
        if let address = dict[API_GetClientInfo.address] as? String {
            c_data.address = address
        } else {
            LogCat.printError(tag: "GetClientInfo", message: "Unable to find value for \(API_GetClientInfo.address)")
        }
        
        if let email = dict[API_GetClientInfo.email] as? String {
            c_data.email = email
        } else {
            LogCat.printError(tag: "GetClientInfo", message: "Unable to find value for \(API_GetClientInfo.email)")
        }
        
        //LogCat.printError(tag: "GetClientInfo", message: "\(c_data)")
        return c_data
    }
    
    func retrieveHardCodedInfo(username: String) -> ClientData {
        var c_data: ClientData = ClientData()
        c_data.username = username
        c_data.NIN = "01232138979012"
        c_data.clientId = 2
        c_data.password = "password"
        c_data.name = "Mohamed Tawfik"
        c_data.address = "57 Street 90, Fifth Settlement, Cairo, Egypt"
        c_data.phone = "01096545821"
        c_data.email = "mohamed@aucegypt.edu"
        return c_data
    }
    
    
}
