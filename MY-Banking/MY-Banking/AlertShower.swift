//
//  API_Register.swift
//  MY-Banking
//
//  Created by Mohamed A Tawfik on Jul/1/18.
//  Copyright © 2018 Mohamed A Tawfik. All rights reserved.
//

import Foundation
import UIKit


class AlertShower {
    /**
     it shows an alert using SweetAlert
     */
    class func showSweetAlert(onCondition: Bool, title: String, message: String?, style: AlertStyle) {
        if onCondition {
            _ = SweetAlert().showAlert(title, subTitle: message, style: style)
        }
    }
    /**
     it shows an alert using SweetAlert, then executes the closure the view controller
     */
    class func showSweetAlertAndExecute(onCondition: Bool, title: String, message: String?, style: AlertStyle, buttonTitle: String, action: ((_ isOtherButton: Bool) -> Void)? = nil) {
        if onCondition {
            _ = SweetAlert().showAlert(title, subTitle: message, style: style, buttonTitle: buttonTitle, action: action)
        } else {
            if action != nil {
                action!(false)
            }
        }
    }
    /**
     it shows an alert using SweetAlert, then closes the view controller
     */
    class func showSweetAlertAndClose(onCondition: Bool, title: String, message: String?, style: AlertStyle, buttonTitle: String, vC: UIViewController) {
        showSweetAlertAndExecute(onCondition: onCondition, title: title, message: message, style: style, buttonTitle: buttonTitle, action: { (isOtherButton: Bool) -> Void in
            vC.dismiss(animated: false, completion: nil)
        })
    }
    /**
     it shows a warning message using SweetAlert
     */
    class func showWarningAlert(title: String, message: String?) {
        _ = SweetAlert().showAlert(title, subTitle: message, style: AlertStyle.warning)
    }
    /**
     it shows an error message using SweetAlert
     */
    class func showErrorAlert(title: String, message: String?) {
        _ = SweetAlert().showAlert(title, subTitle: message, style: AlertStyle.error)
    }
    /**
     it shows a success message using SweetAlert
     */
    class func showSuccessAlert(title: String, message: String?) {
        _ = SweetAlert().showAlert(title, subTitle: message, style: AlertStyle.success)
    }
}
