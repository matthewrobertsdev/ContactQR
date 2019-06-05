//
//  ScanQR_VC.swift
//  CardQR
//
//  Created by Matt Roberts on 6/5/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//

import UIKit
import Photos

class ScanQR_VC: UIImagePickerController, UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    override func viewDidLoad() {
        delegate=self
        sourceType = .camera
        showsCameraControls=false
        
        /*
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            // The user has previously granted access to the camera.
            break
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                if !granted {
                    self.setupResult = .notAuthorized
                }
            })
            
        default:
            // The user has previously denied access.
            setupResult = .notAuthorized
        }
 */
    }
}
