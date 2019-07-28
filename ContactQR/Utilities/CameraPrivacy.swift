//
//  CameraPrivacy.swift
//  ContactQR
//
//  Created by Matt Roberts on 7/28/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//
import UIKit
import Photos
class CameraPrivacy: Privacy {
    static func cameraCheck(viewController: UIViewController, appName: String, completionHandler: @escaping () -> Void) -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        //if authorization is not determined, request it
        case .notDetermined:
            var authorized=false
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                authorized=granted
                if granted {
                    DispatchQueue.main.async {
                        completionHandler()
                    }
                }
            }
            return authorized
        //if authorization is restricted, request that the user goes to privacy settings
        case .restricted:
            showCameraPrivacyAlert(viewController: viewController, appName: appName)
            return false
        //if authorization is denied, request that the user goes to privacy settings
        case .denied:
            showCameraPrivacyAlert(viewController: viewController, appName: appName)
            return false
        //if authorization is authorized and camera is available, return true so that the tab can be shwon
        case .authorized:
            //if no camera is available, return false
            if !UIImagePickerController.isSourceTypeAvailable( .camera) {
                showCameraUnavailableAlert(fromViewController: viewController, appName: appName)
                return false
            }
            //so qr code scanner can be shown
            return true
        @unknown default:
            return false
        }
    }
    static func showCameraPrivacyAlert(viewController: UIViewController, appName: String) {
        DispatchQueue.main.async {
            let permissionString=" doesn't have permission to use the camera.  Please change privacy settings."
            let privacyString = appName+permissionString
            let comment="Alert message when the user has denied access to the camera."
            let message = NSLocalizedString(privacyString, comment: comment)
            let privacyAlert=Privacy.createPrivacyAlert(message: message, appName: appName)
            viewController.present(privacyAlert, animated: true)
        }
    }
    static func showCameraUnavailableAlert(fromViewController: UIViewController, appName: String) {
        DispatchQueue.main.async {
            let privacyString = "You have allowed acccess to the camera, but your device does not have one available."
            let comment="Alert message when the user has given access to camera, but device has none available."
            let message = NSLocalizedString(privacyString, comment: comment)
            let alertController = UIAlertController(title: appName, message: message, preferredStyle: .alert)
            let okNSLocalizedString=NSLocalizedString("OK", comment: "Alert OK button")
            alertController.addAction(UIAlertAction(title: okNSLocalizedString, style: .cancel, handler: nil))
            fromViewController.present(alertController, animated: true, completion: nil)
        }
    }
}
