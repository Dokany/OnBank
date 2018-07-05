//
//  DeleteEmployeeHandler.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/4/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation

class DeleteEmployeeHandler {
    let delegate : DeleteEmployeeDelegate
    
    init(delegate : DeleteEmployeeDelegate) {
        self.delegate = delegate
    }
    
    /**
     This method is called to attempt to delete an employee
     */
    func deleteEmployee (username: String,type: String){
        let Api_deleteEmployee = API_DeleteEmployee()
        Api_deleteEmployee.request(username: username, type: type, completionHandler: { data, response, error in
            if error == nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [.allowFragments]) as? [String: AnyObject]
                    if let dict = json {
                        if let success = dict[API_DeleteEmployee.success] as? Int {
                            var result: Bool
                            if success == 0 {
                                result = false
                            } else {
                                result = true
                            }
                            self.delegate.onEmployeeDeleted(result: result)
                        } else {
                            LogCat.printError(tag: "DeleteEmployee", message: "Unable to find value for \(API_DeleteEmployee.success)")
                        }
                    } else {
                        LogCat.printError(tag: "DeleteEmployee", message: "Unable to cast result as json")
                    }
                } catch _ {
                    LogCat.printError(tag: "DeleteEmployee", message: "Unkown error while reading returned result")
                }
            } else {
                LogCat.printError(tag: "DeleteEmployee", message: error!.localizedDescription)
            }
        })
        
    }
}




