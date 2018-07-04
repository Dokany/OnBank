//
//  API_TellerTransaction.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/4/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation

class API_TellerTransaction {
    static let tellerId = "teller"
    static let acctno = "acctno"
    static let amount = "amount"
    static let success = "success"
    
    init(){}
    
    func request(tellerId: Int, acctno: Int, amount: String, is_deposit: Bool, completionHandler: @escaping completed) {
        let json = [API_TellerTransaction.tellerId: tellerId, API_TellerTransaction.acctno: acctno, API_TellerTransaction.amount: amount] as [String: Any]
        
        var url_string = Constants.baseURL + "withdraw"
        if is_deposit {
           url_string = Constants.baseURL + "deposit"
        }
        let urlString = URL(string: url_string)
        let request = NSMutableURLRequest(url: urlString!)
        
        request.httpMethod = "POST"
        request.cachePolicy = .reloadIgnoringCacheData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
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

