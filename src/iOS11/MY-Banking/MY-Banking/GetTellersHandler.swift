//
//  GetTellersHandler.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/4/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation

class GetTellersHandler {
    let delegate : GetTellersDelegate
    
    init(delegate : GetTellersDelegate) {
        self.delegate = delegate
    }
    
    func getTellers (){
        let Api_getTellers = API_GetTellers()
        Api_getTellers.request(completionHandler: { data, response, error in
            LogCat.printError(tag: "GetTellers", message: "\(String(data: data!, encoding: String.Encoding.utf8)!)")
            if error == nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [.allowFragments]) as? [String: AnyObject]
                    if let dict = json {
                        self.buildTellersAndNotifyDelegate(dict: dict)
                    } else {
                        LogCat.printError(tag: "GetTellers", message: "Unable to cast result as json")
                    }
                } catch _ {
                    LogCat.printError(tag: "GetTellers", message: "Unkown error while reading returned result")
                }
            } else {
                LogCat.printError(tag: "GetTellers", message: error!.localizedDescription)
            }
        })
        
    }
    
    private func buildTellersAndNotifyDelegate(dict: [String: AnyObject]) {
        if let number = dict[API_GetTellers.number] as? Int {
            var tellers = [Teller()]
            tellers.removeAll()
            if number < 1 {
                self.delegate.tellersReceived(tellers: nil)
                return
            } else {
                for i in 0...(number-1) {
                    if let element = dict[String(i)] as? [String: AnyObject] {
                        if let teller = self.buildTeller(element: element) {
                            tellers.append(teller)
                        } else {
                            LogCat.printError(tag: "GetTellers", message: "Unable to unpack admin")
                        }
                    } else {
                        LogCat.printError(tag: "GetTellers", message: "Unable to unpack admin \(i)")
                    }
                }
            }
            
            if tellers.count > 0 {
                self.delegate.tellersReceived(tellers: tellers)
            } else {
                self.delegate.tellersReceived(tellers: nil)
            }
            
        } else {
            LogCat.printError(tag: "GetTellers", message: "Unable to retrieve number of tellers")
            self.delegate.tellersReceived(tellers: nil)
        }
    }
    
    private func buildTeller(element: [String: AnyObject]) -> Teller? {
        var teller: Teller? = nil
        
        if let id = element[API_GetTellers.id] as? Int {
            if let username = element[API_GetTellers.username] as? String {
                teller = Teller()
                teller?.id = id
                teller?.username = username
            }
        }
        return teller
    }
}



