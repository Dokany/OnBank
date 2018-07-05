//
//  AddEmployeeHandler.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/4/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation

class AddEmployeeHandler {
    let delegate : AddEmployeeDelegate
    
    init(delegate : AddEmployeeDelegate) {
        self.delegate = delegate
    }
    
    /**
     This method is called to attempt to delete an employee
     */
    func addEmployee (username: String, password: String, type: String){
        LogCat.printError(tag: "AddEmployee", message: "Z")
        let Api_addEmployee = API_AddEmployee()
        Api_addEmployee.request(username: username, password: password, type: type, completionHandler: { data, response, error in
            LogCat.printError(tag: "AddEmployee", message: "4")
            LogCat.printError(tag: "AddEmployee", message: String(data: data!, encoding: String.Encoding.utf8)!)
            LogCat.printError(tag: "AddEmployee", message: "5")

            if error == nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [.allowFragments]) as? [String: AnyObject]
                    LogCat.printError(tag: "AddEmployee", message: "6")
                    if let dict = json {
                        LogCat.printError(tag: "AddEmployee", message: "7")
                        if let success = dict[API_AddEmployee.success] as? Int {
                            var result: Bool
                            if success == 0 {
                                result = false
                            } else {
                                result = true
                            }
                            LogCat.printError(tag: "AddEmployee", message: "8")
                            self.delegate.onEmployeeAdded(result: result)
                            return;
                        } else {
                            LogCat.printError(tag: "AddEmployee", message: "Unable to find value for \(API_AddEmployee.success)")
                            self.delegate.onEmployeeAdded(result: false)

                        }
                    } else {
                        LogCat.printError(tag: "AddEmployee", message: "Unable to cast result as json")
                        self.delegate.onEmployeeAdded(result: false)
                    }
                } catch _ {
                    LogCat.printError(tag: "AddEmployee", message: "Unkown error while reading returned result")
                    self.delegate.onEmployeeAdded(result: false)
                }
            } else {
                LogCat.printError(tag: "AddEmployee", message: error!.localizedDescription)
                self.delegate.onEmployeeAdded(result: false)
            }
        })
        
    }
}





