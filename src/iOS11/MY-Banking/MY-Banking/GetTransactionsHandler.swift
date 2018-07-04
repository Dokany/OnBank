//
//  GetTransactionsHandler.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/3/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation

class GetTransactionsHandler {
    let delegate : GetTransactionssDelegate
    
    init(delegate : GetTransactionssDelegate) {
        self.delegate = delegate
    }
    
    func getTransactions (acctno: Int){
       buildHardCodedTransactionsAndNotifyDelegate()
       return;
        
        let Api_getTransactions = API_GetTransactions()
        Api_getTransactions.request(acctno: acctno, completionHandler: { data, response, error in
            LogCat.printError(tag: "GetTransactions", message: String(data: data!, encoding: String.Encoding.utf8)!)
            if error == nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [.allowFragments]) as? [String: AnyObject]
                    if let dict = json {
                        if let number = dict[API_GetTransactions.number] as? Int {
                            if number > 0 {
                                self.buildTransactionsAndNotifyDelegate(dict: dict)
                            } else {
                                self.delegate.transactionsReceived(transactions: nil)
                            }
                            
                        } else {
                            LogCat.printError(tag: "GetTransactions", message: "Unable to find value for \(API_GetTransactions.number)")
                            self.delegate.transactionsReceived(transactions: nil)
                        }
                    } else {
                        LogCat.printError(tag: "GetTransactions", message: "Unable to cast result as json")
                        self.delegate.transactionsReceived(transactions: nil)
                    }
                } catch _ {
                    LogCat.printError(tag: "GetTransactions", message: "Unkown error while reading returned result")
                    self.delegate.transactionsReceived(transactions: nil)
                }
            } else {
                LogCat.printError(tag: "GetTransactions", message: error!.localizedDescription)
                self.delegate.transactionsReceived(transactions: nil)
            }
        })
         
    }
    
    func buildTransactionsAndNotifyDelegate(dict: [String: AnyObject]) {
        if let number = dict[API_GetTransactions.number] as? Int {
            var transactions = [Transaction()]
            transactions.removeAll()
            for i in 0...(number-1) {
                if let element = dict[String(i)] as? [String: AnyObject] {
                    if let transaction = self.buildTransaction(element: element) {
                        transactions.append(transaction)
                    } else {
                        LogCat.printError(tag: "GetTransactions", message: "Error unpacking trnasaction")
                    }
                } else {
                    LogCat.printError(tag: "GetTransactions", message: "Unable to unpack trnasaction \(i)")
                }
            }
            
            if transactions.count > 0 {
                self.delegate.transactionsReceived(transactions: transactions)
            } else {
                self.delegate.transactionsReceived(transactions: nil)
            }
            
        } else {
            LogCat.printError(tag: "GetTransactions", message: "Unable to retrieve number of transactions")
            self.delegate.transactionsReceived(transactions: nil)
        }
        
    }
    
    func buildTransaction(element: [String: AnyObject]) -> Transaction? {
        var transaction: Transaction? = nil
        
        if let id = element[API_GetTransactions.id] as? Int {
            if let date = element[API_GetTransactions.date] as? String {
                if let amount = element[API_GetTransactions.amount] as? String {
                    transaction = Transaction()
                    transaction?.number = id
                    transaction?.date = date
                    transaction?.amount = amount
                    transaction?.teller = element[API_GetTransactions.teller] as? Int
                    }
                }
            }
        
        return transaction
    }
        
    
    func buildHardCodedTransactionsAndNotifyDelegate() {
        var transactions = [Transaction()]
        
        transactions.removeAll()
       
        transactions.append(Transaction(number: 1234, date: "25-Jun-2018", amount: "172.5", teller: 2))
         transactions.append(Transaction(number: 5678, date: "25-Mar-2016", amount: "-18", teller: nil))

        self.delegate.transactionsReceived(transactions: transactions)
    }
    
    
}
