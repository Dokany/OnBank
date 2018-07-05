//
//  AllTransactionsDelegate.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/4/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation

protocol AllTransactionsDelegate: class {
    /**
     This method is called when the transactions are retreived from the database
     */
    func onTransactionsReceived(transactions: [Transaction]?)
}

