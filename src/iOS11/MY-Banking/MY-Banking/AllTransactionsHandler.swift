//
//  AllTransactionsHandler.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/4/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation

class AllTransactionsHandler {
    private let delegate : AllTransactionsDelegate
    
    init(delegate : AllTransactionsDelegate) {
        self.delegate = delegate
    }
    
    func allTransactions(){
       // buildHardCodedTransactionsAndNotifyDelegate()
        //return;
        
        let Api_allTransactions = API_AllTransactions()
        Api_allTransactions.request(completionHandler: { data, response, error in
            LogCat.printError(tag: "AllTransactions", message: String(data: data!, encoding: String.Encoding.utf8)!)
            if error == nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [.allowFragments]) as? [String: AnyObject]
                    if let dict = json {
                        if let number = dict[API_AllTransactions.number] as? Int {
                            if number > 0 {
                                self.buildTransactionsAndNotifyDelegate(dict: dict)
                            } else {
                                self.delegate.onTransactionsReceived(transactions: nil)
                            }
                            
                        } else {
                            LogCat.printError(tag: "AllTransactions", message: "Unable to find value for \(API_AllTransactions.number)")
                            self.delegate.onTransactionsReceived(transactions: nil)
                        }
                    } else {
                        LogCat.printError(tag: "AllTransactions", message: "Unable to cast result as json")
                        self.delegate.onTransactionsReceived(transactions: nil)
                    }
                } catch _ {
                    LogCat.printError(tag: "AllTransactions", message: "Unkown error while reading returned result")
                    self.delegate.onTransactionsReceived(transactions: nil)
                }
            } else {
                LogCat.printError(tag: "AllTransactions", message: error!.localizedDescription)
                self.delegate.onTransactionsReceived(transactions: nil)
            }
        })
        
    }
    
    private func buildTransactionsAndNotifyDelegate(dict: [String: AnyObject]) {
        if let number = dict[API_AllTransactions.number] as? Int {
            var transactions = [Transaction()]
            transactions.removeAll()
            if number < 1 {
                self.delegate.onTransactionsReceived(transactions: nil)
                return
            } else {
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
            }
            
            if transactions.count > 0 {
                self.delegate.onTransactionsReceived(transactions: transactions)
            } else {
                self.delegate.onTransactionsReceived(transactions: nil)
            }
            
        } else {
            LogCat.printError(tag: "GetTransactions", message: "Unable to retrieve number of transactions")
            self.delegate.onTransactionsReceived(transactions: nil)
        }
        
    }
    
    private func buildTransaction(element: [String: AnyObject]) -> Transaction? {
        var transaction: Transaction? = nil
        
        if let id = element[API_AllTransactions.id] as? Int {
            if let date = element[API_AllTransactions.date] as? String {
                if let amount = element[API_AllTransactions.amount] as? String {
                    if let currency = element[API_AllTransactions.currency] as? String {
                        transaction = Transaction()
                        transaction?.number = id
                        transaction?.date = date
                        transaction?.amount = amount
                        transaction?.currency = currency
                        transaction?.teller = element[API_AllTransactions.teller] as? Int
                        transaction?.acctno = element[API_AllTransactions.acctno] as? Int
                    }
                }
            }
        }
        
        return transaction
    }
    
    
    private func buildHardCodedTransactionsAndNotifyDelegate() {
        var transactions = [Transaction()]
        
        transactions.removeAll()
        
        transactions.append(Transaction(number: 1234, date: "25-Jun-2018", amount: "172.5", teller: 2, acctno: 2, currency: "EGP"))
        transactions.append(Transaction(number: 5678, date: "25-Mar-2016", amount: "-18", teller: nil, acctno: 7, currency: "USD"))
        
        self.delegate.onTransactionsReceived(transactions: transactions)
    }
    
    
}

