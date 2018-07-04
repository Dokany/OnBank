//
//  API_AddAccount.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/4/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation

class API_AddAccount {
    static let clientId = "client"
    static let type = "type"
    static let type_current = "current"
    static let type_savings = "savings"
    static let success = "success"
    
    init(){}
    
    func request(clientId: Int, type: AccountType, completionHandler: @escaping completed) {
        var a_type = API_AddAccount.type_savings
        if type == .Current {
            a_type = API_AddAccount.type_current
        }
        
        let url_string = Constants.baseURL + "addAccount"
        let urlString = URL(string: url_string)
        let request = NSMutableURLRequest(url: urlString!)
        
        request.httpMethod = "POST"
        request.cachePolicy = .reloadIgnoringCacheData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json = [API_AddAccount.clientId: clientId, API_AddAccount.type: a_type] as [String : Any]
        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        request.httpBody = jsonData
        
        do {
            let task = URLSession.shared.dataTask(with: (request as URLRequest)) { (data, response, error) in
                DispatchQueue.main.async {
                    completionHandler(data, response, error)
                }
            }
            task.resume()
        }
    }
}
