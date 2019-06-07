//
//  TabBarController.swift
//  CardQR
//
//  Created by Matt Roberts on 6/5/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//

import UIKit
import Photos
import Contacts

class TabBarController: UITabBarController, UITabBarControllerDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate=self
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController,shouldSelect viewController: UIViewController) -> Bool{
        
        //if user is trying to go to ScanQR_VC
        if (viewController is ScanQR_VC){
            return cameraPrivacyCheck() && contactPrivacyCheck()
        }
        
        //if it's any othe view controller that the UITabBarController is trying to present, just return true so that it will do it
        return true
    }
    
    func cameraPrivacyCheck()->Bool{
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
            
            showCameraPrivacyAlert()
            return false
            
        //if authorization is denied, request that the user goes to privacy settings
        case .denied:
            
            showCameraPrivacyAlert()
            return false
            
        //if authorization is authorized and camera is available, return true so that the tab can be shwon
        case .authorized:
            
            //if no camera is available, return false
            if (!UIImagePickerController.isSourceTypeAvailable( .camera)){
                showCameraUnavailableAlert()
                return false;
            }
            //so qr code scanner can be shown
            return true
            
        }
    }
    
    func contactPrivacyCheck()->Bool{
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
            
            showContactPrivacyAlert()
            return false
            
        //if authorization is denied, request that the user goes to privacy settings
        case .denied:
            
            showContactPrivacyAlert()
            return false
            
        //if authorization is authorized and camera is available, return true so that the tab can be shwon
        case .authorized:
            
            //so qr code scanner can be shown
            return true
            
        }
    }
    
    func showContactPrivacyAlert(){
        DispatchQueue.main.async {
            print("Requesting permission")
            let changePrivacySetting = AppStringConstants.APP_NAME+" doesn't have permission to access your Contacts.  Please change privacy settings."
            let alertMessage = NSLocalizedString(changePrivacySetting, comment: "Alert message when the user has denied access to Contacts.")
            self.present(Alerts.makeUpdatePrivacyAlert(alertMessage: alertMessage), animated: true, completion: nil)
        }
    }
    
    func showCameraPrivacyAlert(){
        DispatchQueue.main.async {
            print("Requesting permission")
            let changePrivacySetting = AppStringConstants.APP_NAME+" doesn't have permission to use the camera.  Please change privacy settings."
            let alertMessage = NSLocalizedString(changePrivacySetting, comment: "Alert message when the user has denied access to the camera.")
            self.present(Alerts.makeUpdatePrivacyAlert(alertMessage: alertMessage), animated: true, completion: nil)
        }
    }
    
    func showCameraUnavailableAlert(){
        DispatchQueue.main.async {
            print("Camera unavailable")
            let changePrivacySetting = "You have allowed acccess to the camera, but your device does not have a camera available."
            let alertMessage = NSLocalizedString(changePrivacySetting, comment: "Alert message when the user has given access to the camera, but the device doesn''t have one available.")
            let alertController = UIAlertController(title: AppStringConstants.APP_NAME, message: alertMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"),style: .cancel,handler: nil))
            self.present(alertController, animated: true, completion: nil)

            
        }
    }
    
}
