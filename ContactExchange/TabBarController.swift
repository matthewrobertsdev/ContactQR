//
//  TabBarController.swift
//  CardQR
//
//  Created by Matt Roberts on 6/5/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate=self
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController,shouldSelect viewController: UIViewController) -> Bool{
        
        //if user is trying to go to ScanQR_VC
        if (viewController is GetQR_VC){
            return PrivacyPermissions.cameraPrivacyCheck(presentingVC: self) && PrivacyPermissions.contactPrivacyCheck(presentingVC: self)
        }
        
        //if it's any othe view controller that the UITabBarController is trying to present, just return true so that it will do it
        return true
    }
    
    
    
}
