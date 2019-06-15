//
//  ScanQR_VC.swift
//  CardQR
//
//  Created by Matt Roberts on 6/5/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//

import UIKit
import AVFoundation
import Contacts

class GetQR_VC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //the view for scanning qr codes
    @IBOutlet weak var scanView: UIView!
    
    //the banner you tap to save a code or dismiss a code that isn't a contact
    @IBOutlet weak var saveContactBanner: SaveContactBanner!
    
    
    //the controller where it all happens
    var controller: GetQRController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controller=GetQRController(scanQR_VC: self)
    }
    
    
    
}
