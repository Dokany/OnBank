//
//  AddAccountDelegate.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/4/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation

protocol AddAccountDelegate: class {
    /**
     This method is called when the teller attempts to add an account
     */
    func onAccountAdded(result: Bool)
}
