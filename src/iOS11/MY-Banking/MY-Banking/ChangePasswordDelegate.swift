//
//  ChangePasswordDelegate.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/1/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation

protocol ChangePasswordDelegate: class {
    /**
     This method is called when the user attempts to change their password
     */
    func userDidAttemptChangePassword(result: Bool)
}
