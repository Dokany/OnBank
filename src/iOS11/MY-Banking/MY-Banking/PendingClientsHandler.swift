//
//  PendingClientsHandler.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/4/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation

class PendingClientstHandler {
    private let delegate : PendingClientsDelegate
    
    init(delegate : PendingClientsDelegate) {
        self.delegate = delegate
    }
    
    func pendingClients(){
      //  buildHardCodedPendingClientsAndNotifyDelegate()
      //  return;
        
        let Api_pendingClients = API_PendingClients()
        Api_pendingClients.request(completionHandler: { data, response, error in
            LogCat.printError(tag: "PendingClients", message: String(data: data!, encoding: String.Encoding.utf8)!)
            if error == nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [.allowFragments]) as? [String: AnyObject]
                    if let dict = json {
                        if let number = dict[API_PendingClients.number] as? Int {
                            if number > 0 {
                                self.buildPendingClientsAndNotifyDelegate(dict: dict)
                            } else {
                                self.delegate.onPendingClientsReceived(pending_clients: nil)
                            }
                            
                        } else {
                            LogCat.printError(tag: "PendingClients", message: "Unable to find value for \(API_PendingClients.number)")
                            self.delegate.onPendingClientsReceived(pending_clients: nil)
                        }
                    } else {
                        LogCat.printError(tag: "PendingClients", message: "Unable to cast result as json")
                        self.delegate.onPendingClientsReceived(pending_clients: nil)
                    }
                } catch _ {
                    LogCat.printError(tag: "PendingClients", message: "Unkown error while reading returned result")
                    self.delegate.onPendingClientsReceived(pending_clients: nil)
                }
            } else {
                LogCat.printError(tag: "PendingClients", message: error!.localizedDescription)
                self.delegate.onPendingClientsReceived(pending_clients: nil)
            }
        })
        
    }
    
    private func buildPendingClientsAndNotifyDelegate(dict: [String: AnyObject]) {
        if let number = dict[API_PendingClients.number] as? Int {
            var pending_clients = [PendingClient()]
            pending_clients.removeAll()
            if number < 1 {
                self.delegate.onPendingClientsReceived(pending_clients: nil)
                return
            } else {
                for i in 0...(number-1) {
                    if let element = dict[String(i)] as? [String: AnyObject] {
                        if let client = self.buildPendingClient(element: element) {
                            pending_clients.append(client)
                        } else {
                            LogCat.printError(tag: "PendingClients", message: "Error unpacking client")
                        }
                    } else {
                        LogCat.printError(tag: "PendingClients", message: "Unable to unpack client \(i)")
                    }
                }
            }
            
            if pending_clients.count > 0 {
                self.delegate.onPendingClientsReceived(pending_clients: pending_clients)
            } else {
                self.delegate.onPendingClientsReceived(pending_clients: nil)
            }
            
        } else {
            LogCat.printError(tag: "PendingClients", message: "Unable to retrieve number of clients")
            self.delegate.onPendingClientsReceived(pending_clients: nil)
        }
        
    }
    
    private func buildPendingClient(element: [String: AnyObject]) -> PendingClient? {
        var pending_client: PendingClient? = nil
        
        if let nin = element[API_PendingClients.NIN] as? String {
            if let name = element[API_PendingClients.name] as? String {
                pending_client = PendingClient()
                pending_client?.NIN = nin
                pending_client?.name = name
                
            }
        }
        
        return pending_client
    }
    
    
    private func buildHardCodedPendingClientsAndNotifyDelegate() {
        var pending_clients = [PendingClient()]
        
        pending_clients.removeAll()
        
        pending_clients.append(PendingClient(NIN: "1234", name: "Seif"))
        pending_clients.append(PendingClient(NIN: "5678", name: "Farah"))
        
        self.delegate.onPendingClientsReceived(pending_clients: pending_clients)
    }
    
    
}
