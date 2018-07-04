//
//  Api_ChangePassword.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/1/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

// Add new types

import Foundation

class API_ChangePassword {
    static let username = "username"
    static let password = "password"
    static let success = "success"
    
    init(){}
    
    func request(username: String, password: String, type: String, completionHandler: @escaping completed) {
        let urlString = URL(string: Constants.baseURL + self.getAPI(type: type))
        let request = NSMutableURLRequest(url: urlString!)
        request.httpMethod = "POST"
        request.cachePolicy = .reloadIgnoringCacheData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json = [API_ChangePassword.username: username, API_ChangePassword.password: password] as [String : Any]
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
    
    private func getAPI(type: String) -> String{
        if type == "client" {
            return "changeClientPass"
        } else if type == "admin" {
            return "changeAdminPass"
        } else {
            return "changeTellerPass"
        }
    }
    
}

