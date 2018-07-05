//
//  API_ApproveApplication.swift
//  MY-Banking
//
/******************************************
 CSCE 253/2501
 Summer 2018
 Project 1
 
 Mohamed T Abdelrahman (ID no. 900142457)
 Yasmin ElDokany (ID no. 900131538)
 ******************************************/


import Foundation

class API_ApproveApplication {
    static let NIN = "NIN"
    static let adminID = "adminId"
    static let success = "success"
    
    init(){}
    
    func request(NIN: String, adminID: Int, completionHandler: @escaping completed) {
        let urlString = URL(string: Constants.baseURL + "approvePending")
        let request = NSMutableURLRequest(url: urlString!)
        request.httpMethod = "POST"
        request.cachePolicy = .reloadIgnoringCacheData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let json = [API_ApproveApplication.NIN: NIN, API_ApproveApplication.adminID: adminID] as [String : Any]
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
