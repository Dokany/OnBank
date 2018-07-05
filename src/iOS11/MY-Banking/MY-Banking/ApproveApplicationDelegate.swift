//
//  ApproveApplicationDelegate.swift
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

protocol ApproveApplicationDelegate: class {
    /**
     This method is called when to tell whether the application was approved or not
     */
    func isApplication(approved: Bool)
}
