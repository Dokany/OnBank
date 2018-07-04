//
//  PerformTransactionHandler.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/3/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation

class PerformTransactionHandler {
    let delegate : PerformTransactionDelegate
    
    init(delegate : PerformTransactionDelegate) {
        self.delegate = delegate
    }
    
    func performTransaction (clientId: Int, sending_account: Int, receiving_account: Int, amount: String){
        //self.delegate.transactionResult(result: true)
       // return;
        
        let Api_performTransaction = API_PerformTransaction()
        Api_performTransaction.request(clientId: clientId, sending_account: sending_account, receiving_account: receiving_account, amount: amount, completionHandler: { data, response, error in
            LogCat.printError(tag: "PerformTransaction", message: "\(String(data: data!, encoding: String.Encoding.utf8)!)")

            if error == nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [.allowFragments]) as? [String: AnyObject]
                    if let dict = json {
                        if let success = dict[API_PerformTransaction.success] as? Int {
                            var result: Bool
                            if success == 0 {
                                result = false
                            } else {
                                result = true
                            }
                            self.delegate.transactionResult(result: result)
                        } else {
                            LogCat.printError(tag: "PerformTransaction", message: "Unable to find value for \(API_PerformTransaction.success)")
                        }
                    } else {
                        LogCat.printError(tag: "PerformTransaction", message: "Unable to cast result as json")
                    }
                } catch _ {
                    LogCat.printError(tag: "PerformTransaction", message: "Unkown error while reading returned result")
                }
            } else {
                LogCat.printError(tag: "PerformTransaction", message: error!.localizedDescription)
            }
        })
    }
    
}

