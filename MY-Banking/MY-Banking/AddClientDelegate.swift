//
//  AddClientDelegate.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/4/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation

protocol AddClientDelegate: class {
    /**
     This method is called when the teller attempts to add a client
     */
    func onClientAdded(result: Bool)
}
