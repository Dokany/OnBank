//
//  GetTellersDelegate.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/4/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation

protocol GetTellersDelegate: class {
    /**
     This method is called when the admin attempts to get all tellers
     */
    func tellersReceived(tellers: [Teller]?)
}
