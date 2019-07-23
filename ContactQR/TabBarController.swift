//
//  TabBarController.swift
//  CardQR
//
//  Created by Matt Roberts on 6/5/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate=self
    }
    func tabBarController(_ tabBarController: UITabBarController, viewController: UIViewController) -> Bool {
        //if user is trying to go to ScanQR_VC
        guard let selectedViewController=tabBarController.viewControllers?[1] else {
            return true
        }
        if viewController==selectedViewController {
            return Privacy.cameraCheck(viewController: self) && Privacy.contactsCheck(viewController: self)
        }
        /*
        if it's any othe view controller that the UITabBarController is
        trying to present, just return true so that it will do it
         */
        return true
    }
}
