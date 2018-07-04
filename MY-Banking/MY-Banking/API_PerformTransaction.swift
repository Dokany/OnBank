//
//  API_PerformTransaction.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/3/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation

class API_PerformTransaction {
    static let clientId = "client"
    static let sending_account = "from"
    static let receiving_account = "to"
    static let amount = "amount"
    static let success = "success"
    
    init(){}
    
    func request(clientId: Int, sending_account: Int, receiving_account: Int, amount: String, completionHandler: @escaping completed) {
        let url_string = Constants.baseURL + "createTransfer"
        let urlString = URL(string: url_string)
        
        let request = NSMutableURLRequest(url: urlString!)
        request.httpMethod = "POST"
        request.cachePolicy = .reloadIgnoringCacheData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json = [API_PerformTransaction.clientId: clientId, API_PerformTransaction.sending_account: sending_account, API_PerformTransaction.receiving_account: receiving_account, API_PerformTransaction.amount: amount] as [String : Any]
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

