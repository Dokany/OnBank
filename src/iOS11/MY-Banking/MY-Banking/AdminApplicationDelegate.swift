//
//  AdminApplicationDelegate.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/5/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation

protocol AdminApplicationDelegate: class {
    /**
     This method is called when the admin attempts to get a pending application
     */
    func onApplicationReceived(application: ClientApplication?)
    
    /**
     This method is called when the admin attempts to get owner info
     */
    func onOwnerInforReceived(name: String?)
}
