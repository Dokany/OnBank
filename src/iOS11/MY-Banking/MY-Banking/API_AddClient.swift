//
//  API_AddClient.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/4/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation

class API_AddClient {
    static let tellerId = "client"
    static let NIN = "NIN"
    static let username = "username"
    static let password = "password"
    static let phone = "phone"
    static let email = "email"
    static let address = "address"
    static let first_name = "fName"
    static let last_name = "lName"
    static let success = "success"
    
    init(){}
    
    func request(tellerId: Int, NIN: String, username: String, password: String, phone: String, email: String, first_name: String, last_name: String, address: String?, completionHandler: @escaping completed) {
        var json: [String : Any]
        if let a = address {
            json = [API_AddClient.tellerId: tellerId, API_AddClient.NIN: NIN, API_AddClient.username: username, API_AddClient.password: password, API_AddClient.phone: phone, API_AddClient.email: email, API_AddClient.first_name: first_name, API_AddClient.last_name: last_name, API_AddClient.address: a]
        } else {
            json = [API_AddClient.tellerId: tellerId, API_AddClient.NIN: NIN, API_AddClient.username: username, API_AddClient.password: password, API_AddClient.phone: phone, API_AddClient.email: email, API_AddClient.first_name: first_name, API_AddClient.last_name: last_name]
        }
        
        let url_string = Constants.baseURL + "addClient"
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
