//
//  GetTransactionDelegate.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/3/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation

protocol GetTransactionssDelegate: class {
    /**
     This method is called when the client attempts to change their info
     */
    func transactionsReceived(transactions: [Transaction]?)
}
