//
//  API_LogIn.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/1/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation

class API_LogIn {
    static let username = "username"
    static let password = "password"
    static let type = "type"
    static let type_client = "client"
    static let type_admin = "admin"
    static let type_teller = "teller"
    static let type_unknown_credentials = "unknown"
    static let id = "id"
    
    
    
    init(){}
    
    func request(username: String, password: String, completionHandler: @escaping completed) {
        let urlString = URL(string: Constants.baseURL + "login")
        let request = NSMutableURLRequest(url: urlString!)
        request.httpMethod = "POST"
        request.cachePolicy = .reloadIgnoringCacheData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json = [API_LogIn.username: username, API_LogIn.password: password] as [String : Any]

        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        //let jsonData = "\(json)".data(using: .utf8)

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
