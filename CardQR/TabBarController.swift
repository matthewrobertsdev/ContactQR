//
//  TabBarController.swift
//  CardQR
//
//  Created by Matt Roberts on 6/5/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//

import UIKit
import Photos

class TabBarController: UITabBarController, UITabBarControllerDelegate{
    
    private var authorized=false

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate=self
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController,shouldSelect viewController: UIViewController) -> Bool{
        print("Trying to show a VC")
        if (viewController is ScanQR_VC){
            switch AVCaptureDevice.authorizationStatus(for: .video){
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { (granted) in
                    self.authorized=granted
                }
            case .restricted:
                showUpdatePrivacyAlert()
                return false
            case .denied:
                showUpdatePrivacyAlert()
                return false
            case .authorized:
                if (!UIImagePickerController.isSourceTypeAvailable( .camera)){
                    showCameraUnavailableAlert()
                    return false;
                }
                let vc=ScanQR_VC()
                self.present(vc, animated: true)
                return true
            }
            return authorized
        }
        return true
    }
    
    func showUpdatePrivacyAlert(){
        DispatchQueue.main.async {
            print("Requesting permission")
            let changePrivacySetting = "CardQR doesn't have permission to use the camera.  Please change privacy settings."
            let alertMessage = NSLocalizedString(changePrivacySetting, comment: "Alert message when the user has denied access to the camera.")
            let alertController = UIAlertController(title: "CardQR", message: alertMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"),style: .cancel,handler: nil))
            alertController.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: "Alert button to open Settings"), style: .default, handler: { _  in UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:],completionHandler: nil)}))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showCameraUnavailableAlert(){
        DispatchQueue.main.async {
            print("Camera unavailable")
            let changePrivacySetting = "You have allowed acccess to the camera, but your device doesn not have a camera available."
            let alertMessage = NSLocalizedString(changePrivacySetting, comment: "Alert message when the user has given access to the camera, but the device doesn''t have one available.")
            let alertController = UIAlertController(title: "CardQR", message: alertMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"),style: .cancel,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }

}
