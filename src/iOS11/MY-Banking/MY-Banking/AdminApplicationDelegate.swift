//
//  AdminApplicationDelegate.swift
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

protocol AdminApplicationDelegate: class {
    /**
     This method is called when the admin attempts to get a pending application
     */
    func onApplicationReceived(application: ClientApplication?)
    
    /**
     This method is called when the admin attempts to get owner info
     */
    func onOwnerInforReceived(name: String?)
}
