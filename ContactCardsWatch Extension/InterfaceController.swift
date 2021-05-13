//
//  InterfaceController.swift
//  ContactCardsWatch Extension
//
//  Created by Matt Roberts on 4/11/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import WatchKit
import Foundation
import WatchConnectivity
class InterfaceController: WKInterfaceController, WCSessionDelegate {
	@IBOutlet weak var image: WKInterfaceImage!
	
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
		if WCSession.isSupported() {
			print("Should activate watch session")
			let session = WCSession.default
			session.delegate = self
			session.activate()
		}
    }
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
	}
	func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
		guard let colorString=message["color"] as? String else {
			return
		}
		guard let vCard=message["vCard"] as? String else {
			return
		}
		guard let title=message["title"] as? String else {
			return
		}
		guard let imageData=message["imageData"] as? Data else {
			return
		}
		let qrCode=UIImage(data: imageData) ?? UIImage()
		image.setImage(qrCode)
	}
}
