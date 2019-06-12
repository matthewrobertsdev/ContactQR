//
//  Alerts.swift
//  CardQR
//
//  Created by Matt Roberts on 6/6/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//

import Foundation
import UIKit

class Alerts{
    
    static func makeUpdatePrivacyAlert(alertMessage: String)->UIAlertController{
            let alertController = UIAlertController(title: AppStringConstants.APP_NAME, message: alertMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"),style: .cancel,handler: nil))
            alertController.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: "Alert button to open Settings"), style: .default, handler: { _  in UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:],completionHandler: nil)}))
        return alertController
        }
    
    
}
