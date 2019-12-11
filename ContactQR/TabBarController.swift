//
//  TabBarController.swift
//  CardQR
//
//  Created by Matt Roberts on 6/5/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//
import UIKit
import AVFoundation
/*
 Checks that user has granted access to camera and contacts before
 allowing the user to go to tab 2, GetQRViewController
 */
class TabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate=self
    }
    //check privacy and request as needed
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        //if user is trying to go to ScanQR_VC
        if viewController==tabBarController.viewControllers?[1] {
            guard let viewController=tabBarController.selectedViewController else {
                return false
            }
			/*
                let cameraCompletionHandler = {() -> Void in*/
                    if !UIImagePickerController.isSourceTypeAvailable( .camera) {
                    CameraPrivacy.showUnavailableAlert(fromViewController: viewController, appName: Constants.APPNAME)
					} else if !(AVCaptureDevice.authorizationStatus(for: .video)==AVAuthorizationStatus.authorized) {
						CameraPrivacy.showCameraPrivacyAlert(viewController: viewController, appName: Constants.APPNAME)
					}
			return AVCaptureDevice.authorizationStatus(for: .video)==AVAuthorizationStatus.authorized
        }
            /*
             if it's any othe view controller that the UITabBarController
		is trying to present, just return true so that it will do it
         */
        return true
    }
}
