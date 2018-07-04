//
//  API_UpdateClientInfo.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/2/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation

class API_UpdateClientInfo {
    static let username = "username"    
    static let phone = "phone"
    static let email = "email"
    static let address = "address"
    static let success = "success"
    
    init(){}
    
    func request(username: String, phone: String, email: String, address: String, completionHandler: @escaping completed) {
        let urlString = URL(string: Constants.baseURL + "updateContact")
        let request = NSMutableURLRequest(url: urlString!)
        request.httpMethod = "POST"
        request.cachePolicy = .reloadIgnoringCacheData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json = [API_UpdateClientInfo.username: username, API_UpdateClientInfo.phone: phone, API_UpdateClientInfo.email: email, API_UpdateClientInfo.address: address] as [String : Any]
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
