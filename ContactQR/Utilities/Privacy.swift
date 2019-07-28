//
//  Privacy.swift
//  ContactQR
//
//  Created by Matt Roberts on 6/6/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//
import UIKit
class Privacy {
    static func createPrivacyAlert(message: String, appName: String) -> UIAlertController {
            let alertController = UIAlertController(title: appName, message: message, preferredStyle: .alert)
        let okNSLocalizedString=NSLocalizedString("OK", comment: "Alert OK button")
        let okAlert=UIAlertAction(title: okNSLocalizedString, style: .cancel, handler: nil)
        alertController.addAction(okAlert)
        let privacyAlertHandler = { (alertAction: UIAlertAction) -> Void in
            let openSettingsUrl=URL(string: UIApplication.openSettingsURLString)!
            UIApplication.shared.open(openSettingsUrl, options: [:], completionHandler: nil)
        }
        let openSettingsString=NSLocalizedString("Settings", comment: "Alert button to open Settings")
        let alertAction=UIAlertAction(title: openSettingsString, style: .default, handler: privacyAlertHandler)
            alertController.addAction(alertAction)
        return alertController
        }
}
