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
class GetQRViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //the view for scanning qr codes
    @IBOutlet weak var scanView: UIView!
    //the banner you tap to save a code or dismiss a code that isn't a contact
    @IBOutlet weak var saveBanner: SaveContactBanner!
    //the banner that appears when a contact is saved
	@IBOutlet weak var savedBanner: ContactSavedBanner!
    //the controller where it all happens
	@IBAction func tapOnView(_ sender: Any) {
		if let tapGesture=sender as? UITapGestureRecognizer {
			controller.focusOnTap(tap: tapGesture)
		}
	}
	var controller: GetQRController!
    override func viewDidLoad() {
        super.viewDidLoad()
        controller=GetQRController(getQRViewController: self)
    }
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
}
