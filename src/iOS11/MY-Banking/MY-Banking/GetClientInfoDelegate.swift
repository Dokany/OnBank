//
//  GetClientInfoDelegate.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/1/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation

protocol GetClientInfoDelegate: class {
    /**
     This method is called when the backend returns the relevant client data
     */
    func clientDataRetrieved(data: ClientData?)
}
