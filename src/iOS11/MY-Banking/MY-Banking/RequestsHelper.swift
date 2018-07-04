//
//  RequestsHelper.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/1/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation

class RequestsHelper {
    class func addFirstOption(url: String, key: String, value: String) -> String {
        return url + "?" + key + "=" + value
    }
    
    class func addOption(url: String, key: String, value: String) -> String {
        return url + "&" + key + "=" + value
    }
}
