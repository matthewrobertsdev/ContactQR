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
class QRInterfaceController: WKInterfaceController, WCSessionDelegate {
	let model=WatchContactStore.sharedInstance
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
		model.updateData(message: message)
		NotificationCenter.default.post(Notification(name: .watchContactUpdated))
		guard let imageData=model.getImageData() else {
			return
		}
		let qrCode=UIImage(data: imageData) ?? UIImage()
		image.setImage(qrCode)
	}
}
