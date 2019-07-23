//
//  Alerts.swift
//  CardQR
//
//  Created by Matt Roberts on 6/6/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//
import Foundation
import UIKit
import Photos
import Contacts
class Privacy {
    static func cameraCheck(viewController: UIViewController) -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        //if authorization is not determined, request it
        case .notDetermined:
            var authorized=false
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                authorized=granted
            }
            return authorized
        //if authorization is restricted, request that the user goes to privacy settings
        case .restricted:
            showCameraPrivacyAlert(viewController: viewController)
            return false
        //if authorization is denied, request that the user goes to privacy settings
        case .denied:
            showCameraPrivacyAlert(viewController: viewController)
            return false
        //if authorization is authorized and camera is available, return true so that the tab can be shwon
        case .authorized:
            //if no camera is available, return false
            if !UIImagePickerController.isSourceTypeAvailable( .camera) {
                showCameraUnavailableAlert(viewController: viewController)
                return false
            }
            //so qr code scanner can be shown
            return true
        @unknown default:
            return false
        }
    }
    static func contactsCheck(viewController: UIViewController) -> Bool {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        //if authorization is not determined, request it
        case .notDetermined:
            var authorized=false
            let cnContactStore=CNContactStore()
            cnContactStore.requestAccess(for: .contacts) { (granted, _ ) in
                authorized=granted
            }
            return authorized
        //if authorization is restricted, request that the user goes to privacy settings
        case .restricted:
            showContactPrivacyAlert(viewController: viewController)
            return false
        //if authorization is denied, request that the user goes to privacy settings
        case .denied:
            showContactPrivacyAlert(viewController: viewController)
            return false
        //if authorization is authorized and camera is available, return true so that the tab can be shwon
        case .authorized:
            //so qr code scanner can be shown
            return true
        @unknown default:
            return false
        }
    }
    static func showContactPrivacyAlert(viewController: UIViewController) {
        DispatchQueue.main.async {
            print("Requesting permission")
            let permissionString=" doesn't have permission to access your Contacts.  Please change privacy settings."
            let changePrivacySetting = Constants.APPNAME+permissionString
            let comment="Alert message when the user has denied access to Contacts."
            let message = NSLocalizedString(changePrivacySetting, comment: comment)
            viewController.present(Privacy.createPrivacyAlert(message: message), animated: true, completion: nil)
        }
    }
    static func showCameraPrivacyAlert(viewController: UIViewController) {
        DispatchQueue.main.async {
            let permissionString=" doesn't have permission to use the camera.  Please change privacy settings."
            let privacyString = Constants.APPNAME+permissionString
            let comment="Alert message when the user has denied access to the camera."
            let message = NSLocalizedString(privacyString, comment: comment)
            viewController.present(Privacy.createPrivacyAlert(message: message), animated: true, completion: nil)
        }
    }
    static func showCameraUnavailableAlert(viewController: UIViewController) {
        DispatchQueue.main.async {
            print("Camera unavailable")
            let privacyString = "You have allowed acccess to the camera, but your device does not have one available."
            let comment="Alert message when the user has given access to camera, but device has none available."
            let message = NSLocalizedString(privacyString, comment: comment)
            let alertController = UIAlertController(title: Constants.APPNAME, message: message, preferredStyle: .alert)
            let okNSLocalizedString=NSLocalizedString("OK", comment: "Alert OK button")
            alertController.addAction(UIAlertAction(title: okNSLocalizedString, style: .cancel, handler: nil))
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    static func createPrivacyAlert(message: String) -> UIAlertController {
            let alertController = UIAlertController(title: Constants.APPNAME, message: message, preferredStyle: .alert)
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
