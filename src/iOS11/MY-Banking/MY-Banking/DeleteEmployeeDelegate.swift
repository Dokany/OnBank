//
//  DeleteEmployeeDelegate.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/4/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation

protocol DeleteEmployeeDelegate: class {
    /**
     This method is called when an admin attempts to delete an employee
     */
    func onEmployeeDeleted(result: Bool)
}

