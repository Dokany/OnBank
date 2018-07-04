//
//  API_GetAccounts.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/2/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation

class API_GetAccounts {
    static let clientId = "clientId"
    static let number = "number"
    static let acctno = "acctno"
    static let balance = "balance"
    static let currency = "currency"
    static let type = "type"
    
    init(){}
    
    func request(clientId: Int, completionHandler: @escaping completed) {
        let url_string = Constants.baseURL + "getAccounts"
        let urlString = URL(string: url_string)
        
        let request = NSMutableURLRequest(url: urlString!)
        request.httpMethod = "POST"
        request.cachePolicy = .reloadIgnoringCacheData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json = [API_GetAccounts.clientId: clientId] as [String : Any]
        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        
        do {
            request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: (request as URLRequest)) { (data, response, error) in
                DispatchQueue.main.async {
                    completionHandler(data, response, error)
                }
            }
            task.resume()
        }
    }
}
