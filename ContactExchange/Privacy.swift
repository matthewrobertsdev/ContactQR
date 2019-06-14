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

class Privacy{
    
    static func cameraPrivacyCheck(presentingVC: UIViewController)->Bool{
        switch AVCaptureDevice.authorizationStatus(for: .video){
            
        //if authorization is not determined, request it
        case .notDetermined:
            
            var authorized=false
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                authorized=granted
            }
            return authorized
            
        //if authorization is restricted, request that the user goes to privacy settings
        case .restricted:
            
            showCameraPrivacyAlert(presentingVC: presentingVC)
            return false
            
        //if authorization is denied, request that the user goes to privacy settings
        case .denied:
            
            showCameraPrivacyAlert(presentingVC: presentingVC)
            return false
            
        //if authorization is authorized and camera is available, return true so that the tab can be shwon
        case .authorized:
            
            //if no camera is available, return false
            if (!UIImagePickerController.isSourceTypeAvailable( .camera)){
                showCameraUnavailableAlert(presentingVC: presentingVC)
                return false;
            }
            //so qr code scanner can be shown
            return true
            
        }
    }
    
    static func contactPrivacyCheck(presentingVC: UIViewController)->Bool{
        switch CNContactStore.authorizationStatus(for: .contacts){
            
        //if authorization is not determined, request it
        case .notDetermined:
            
            var authorized=false
            let cnContactStore=CNContactStore()
            
            cnContactStore.requestAccess(for: .contacts) { (granted, error) in
                authorized=granted
            }
            return authorized
            
        //if authorization is restricted, request that the user goes to privacy settings
        case .restricted:
            
            showContactPrivacyAlert(presentingVC: presentingVC)
            return false
            
        //if authorization is denied, request that the user goes to privacy settings
        case .denied:
            
            showContactPrivacyAlert(presentingVC: presentingVC)
            return false
            
        //if authorization is authorized and camera is available, return true so that the tab can be shwon
        case .authorized:
            
            //so qr code scanner can be shown
            return true
            
        }
    }
    
    static func showContactPrivacyAlert(presentingVC: UIViewController){
        DispatchQueue.main.async {
            print("Requesting permission")
            let changePrivacySetting = AppStringConstants.APP_NAME+" doesn't have permission to access your Contacts.  Please change privacy settings."
            let alertMessage = NSLocalizedString(changePrivacySetting, comment: "Alert message when the user has denied access to Contacts.")
            presentingVC.present(Privacy.makeUpdatePrivacyAlert(alertMessage: alertMessage), animated: true, completion: nil)
        }
    }
    
    static func showCameraPrivacyAlert(presentingVC: UIViewController){
        DispatchQueue.main.async {
            print("Requesting permission")
            let changePrivacySetting = AppStringConstants.APP_NAME+" doesn't have permission to use the camera.  Please change privacy settings."
            let alertMessage = NSLocalizedString(changePrivacySetting, comment: "Alert message when the user has denied access to the camera.")
            presentingVC.present(Privacy.makeUpdatePrivacyAlert(alertMessage: alertMessage), animated: true, completion: nil)
        }
    }
    
    static func showCameraUnavailableAlert(presentingVC: UIViewController){
        DispatchQueue.main.async {
            print("Camera unavailable")
            let changePrivacySetting = "You have allowed acccess to the camera, but your device does not have a camera available."
            let alertMessage = NSLocalizedString(changePrivacySetting, comment: "Alert message when the user has given access to the camera, but the device doesn''t have one available.")
            let alertController = UIAlertController(title: AppStringConstants.APP_NAME, message: alertMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"),style: .cancel,handler: nil))
            presentingVC.present(alertController, animated: true, completion: nil)
            
            
        }
    }
    
    static func makeUpdatePrivacyAlert(alertMessage: String)->UIAlertController{
            let alertController = UIAlertController(title: AppStringConstants.APP_NAME, message: alertMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"),style: .cancel,handler: nil))
            alertController.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: "Alert button to open Settings"), style: .default, handler: { _  in UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:],completionHandler: nil)}))
        return alertController
        }
    
    
}
