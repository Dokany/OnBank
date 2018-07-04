//
//  Extensions.swift
//  AcceptSDK
//
//  Created by Mohamed A Tawfik on Aug/23/17.
//  Copyright © 2017 mahmoud gamal. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
