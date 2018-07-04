//
//  GetAccountsInfoDelegate.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/2/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation

protocol GetAccountsDelegate: class {
    /**
     This method is called when the client attempts to change their info
     */
    func accountsReceived(accounts: [Account]?)
}
