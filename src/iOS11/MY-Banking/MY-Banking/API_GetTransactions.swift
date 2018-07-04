//
//  API_GetTransactions.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/2/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation

class API_GetTransactions {
    static let acctno = "acctno"
    static let number = "number"
    static let id = "id"
    static let teller = "teller"
    static let date = "date"
    static let amount = "amount"
    
    init(){}
    
    func request(acctno: Int, completionHandler: @escaping completed) {
        let url_string = Constants.baseURL + "getTransactions"
        let urlString = URL(string: url_string)
        
        let request = NSMutableURLRequest(url: urlString!)
        request.httpMethod = "POST"
        request.cachePolicy = .reloadIgnoringCacheData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json = [API_GetTransactions.acctno: acctno] as [String : Any]
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
