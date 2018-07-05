//
//  API_AdminApplication.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/5/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation

class API_AdminApplication{
    static let NIN = "NIN"
    static let username = "username"
    static let name = "name"
    static let address = "address"
    static let phone = "phone"
    static let email = "email"
    
    init(){}
    
    func requestApplication(nin: String, completionHandler: @escaping completed) {
        let url_string = Constants.baseURL + "viewPending"
        let urlString = URL(string: url_string)
        
        let request = NSMutableURLRequest(url: urlString!)
        request.httpMethod = "POST"
        request.cachePolicy = .reloadIgnoringCacheData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json = [API_AdminApplication.NIN: nin] as [String : Any]
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
    
    func requestOwner(nin: String, completionHandler: @escaping completed) {
        let url_string = Constants.baseURL + "viewOwner"
        let urlString = URL(string: url_string)
        
        let request = NSMutableURLRequest(url: urlString!)
        request.httpMethod = "POST"
        request.cachePolicy = .reloadIgnoringCacheData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json = [API_AdminApplication.NIN: nin] as [String : Any]
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
