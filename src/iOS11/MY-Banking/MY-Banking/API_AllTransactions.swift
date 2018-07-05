//
//  API_AllTransactions.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/4/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation

class API_AllTransactions {
    static let number = "number"
    static let acctno = "acctno"
    static let id = "id"
    static let date = "date"
    static let amount = "amount"
    static let teller = "teller"
    
    init(){}
    
    func request(completionHandler: @escaping completed) {
        let url_string = Constants.baseURL + "allTransactions"
        let urlString = URL(string: url_string)
        
        let request = NSMutableURLRequest(url: urlString!)
        request.httpMethod = "POST"
        request.cachePolicy = .reloadIgnoringCacheData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
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

