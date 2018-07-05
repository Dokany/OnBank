//
//  API_DeleteEmployee.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/4/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation

class API_DeleteEmployee {
    static let username = "username"
    static let success = "success"
    
    init(){}
    
    func request(username: String, type: String, completionHandler: @escaping completed) {
        let urlString = URL(string: Constants.baseURL + self.getAPI(type: type))
        let request = NSMutableURLRequest(url: urlString!)
        request.httpMethod = "POST"
        request.cachePolicy = .reloadIgnoringCacheData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json = [API_DeleteEmployee.username: username] as [String : Any]
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
    
    private func getAPI(type: String) -> String{
        if type == "admin" {
            return "adminDelete"
        } else {
            return "tellerDelete"
        }
    }
    
}
