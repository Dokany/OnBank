//
//  GetAccountsInfoHandler.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/2/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation

class GetAccountsHandler {
    let delegate : GetAccountsDelegate
    
    init(delegate : GetAccountsDelegate) {
        self.delegate = delegate
    }
    
    func getAccounts (clientId: Int){
      // buildHardCodedAccountsAndNotifyDelegate()
     //  return;
        
        let Api_getAccounts = API_GetAccounts()
        Api_getAccounts.request(clientId: clientId, completionHandler: { data, response, error in
           // LogCat.printError(tag: "GetAccounts", message: "\(String(data: data!, encoding: String.Encoding.utf8)!)")
            if error == nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [.allowFragments]) as? [String: AnyObject]
                    if let dict = json {
                        self.buildAccountsAndNotifyDelegate(dict: dict)
                    } else {
                        LogCat.printError(tag: "GetAccounts", message: "Unable to cast result as json")
                    }
                } catch _ {
                    LogCat.printError(tag: "GetAccounts", message: "Unkown error while reading returned result")
                }
            } else {
                LogCat.printError(tag: "GetAccounts", message: error!.localizedDescription)
            }
        })
 
    }
    
    private func buildAccountsAndNotifyDelegate(dict: [String: AnyObject]) {
        if let number = dict[API_GetAccounts.number] as? Int {
            var accounts = [Account()]
            accounts.removeAll()
            if number < 1 {
                self.delegate.accountsReceived(accounts: nil)
                return
            } else {
                for i in 0...(number-1) {
                    if let element = dict[String(i)] as? [String: AnyObject] {
                        if let account = self.buildAccount(element: element) {
                            accounts.append(account)
                        } else {
                            LogCat.printError(tag: "GetAccounts", message: "Unable to unpack account")
                        }
                    } else {
                        LogCat.printError(tag: "GetAccounts", message: "Unable to unpack account \(i)")
                    }
                }
            }
            
            if accounts.count > 0 {
                self.delegate.accountsReceived(accounts: accounts)
            } else {
                self.delegate.accountsReceived(accounts: nil)
            }
            
        } else {
            LogCat.printError(tag: "GetAccounts", message: "Unable to retrieve number of accounts")
            self.delegate.accountsReceived(accounts: nil)
        }
    }
    
    private func buildAccount(element: [String: AnyObject]) -> Account? {
        var account: Account? = nil
        
        if let e_number = element[API_GetAccounts.acctno] as? Int {
            if let e_curr = element[API_GetAccounts.currency] as? String {
                if let e_balance = element[API_GetAccounts.balance] as? String {
                    if let e_type = element[API_GetAccounts.type] as? String {
                        account = Account()
                        account?.number = e_number
                        account?.curr = e_curr
                        account?.balance = e_balance
                        account?.acc_type = e_type
                    }
                }
            }
        }
        
        return account
    }
    
    private func buildHardCodedAccountsAndNotifyDelegate() {
        var accounts = [Account()]
        
        accounts.removeAll()
        accounts.append(Account(number: 2, balance: "124.5", acc_type: "Current", curr: "USD"))
        accounts.append(Account(number: 3213, balance: "165424", acc_type: "Savings", curr: "EGP"))
        
        self.delegate.accountsReceived(accounts: accounts)
    }
        
    
}

