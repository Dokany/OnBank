//
//  ApproveApplicationHandler.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/5/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation

class ApproveApplicationHandler {
    let delegate : ApproveApplicationDelegate
    
    init(delegate : ApproveApplicationDelegate) {
        self.delegate = delegate
    }
    
    /**
     This method is called to attempt to delete an employee
     */
    func approveApplication (NIN: String, adminId: Int){
       // self.delegate.isApplication(approved: true)
        //return;
        
        let Api_approveApplication = API_ApproveApplication()
        Api_approveApplication.request(NIN: NIN, adminID: adminId, completionHandler: { data, response, error in
            LogCat.printError(tag: "ApproveApplication", message: String(data: data!, encoding: String.Encoding.utf8)!)
            
            if error == nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [.allowFragments]) as? [String: AnyObject]
                    if let dict = json {
                        if let success = dict[API_ApproveApplication.success] as? Int {
                            var result: Bool
                            if success == 0 {
                                result = false
                            } else {
                                result = true
                            }
                            self.delegate.isApplication(approved: result)
                            return;
                        } else {
                            LogCat.printError(tag: "AddEmployee", message: "Unable to find value for \(API_ApproveApplication.success)")
                            self.delegate.isApplication(approved: false)

                        }
                    } else {
                        LogCat.printError(tag: "AddEmployee", message: "Unable to cast result as json")
                        self.delegate.isApplication(approved: false)
                    }
                } catch _ {
                    LogCat.printError(tag: "AddEmployee", message: "Unkown error while reading returned result")
                    self.delegate.isApplication(approved: false)
                }
            } else {
                LogCat.printError(tag: "AddEmployee", message: error!.localizedDescription)
                self.delegate.isApplication(approved: false)
            }
        })
        
    }
}




