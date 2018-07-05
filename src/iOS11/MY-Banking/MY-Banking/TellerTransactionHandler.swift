//
//  TellerTransactionHandler.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/4/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation

class TellerTransactionHandler {
    let delegate : TellerTransactionDelegate
    
    init(delegate : TellerTransactionDelegate) {
        self.delegate = delegate
    }
    
    func performTransaction(tellerId: Int, acctno: Int, amount: String, is_deposit: Bool){
      // self.delegate.onTransactionPerformed(result: true)
      //  return;
        
        let Api_tellerTransaction = API_TellerTransaction()
        Api_tellerTransaction.request(tellerId: tellerId, acctno: acctno, amount: amount, is_deposit: is_deposit, completionHandler: { data, response, error in
            LogCat.printError(tag: "TellerTransaction", message: "\(String(data: data!, encoding: String.Encoding.utf8)!)")
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
                            self.delegate.onTransactionPerformed(result: result)
                        } else {
                            LogCat.printError(tag: "TellerTransaction", message: "Unable to find value for \(API_TellerTransaction.success)")
                        }
                    } else {
                        LogCat.printError(tag: "TellerTransaction", message: "Unable to cast result as json")
                    }
                } catch _ {
                    LogCat.printError(tag: "TellerTransaction", message: "Unkown error while reading returned result")
                }
            } else {
                LogCat.printError(tag: "TellerTransaction", message: error!.localizedDescription)
            }
        })
        
    }
    
}
