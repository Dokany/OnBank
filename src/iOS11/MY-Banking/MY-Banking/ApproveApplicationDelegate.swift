//
//  ApproveApplicationDelegate.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/5/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation

protocol ApproveApplicationDelegate: class {
    /**
     This method is called when to tell whether the application was approved or not
     */
    func isApplication(approved: Bool)
}
