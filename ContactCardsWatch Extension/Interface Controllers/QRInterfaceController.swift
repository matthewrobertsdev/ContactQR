//
//  InterfaceController.swift
//  ContactCardsWatch Extension
//
//  Created by Matt Roberts on 4/11/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import WatchKit
import Foundation
class QRInterfaceController: WKInterfaceController {
	var contactCardMO: ContactCardMO?
	@IBOutlet weak var showDetailsButton: WKInterfaceButton!
	@IBOutlet weak var image: WKInterfaceImage!
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
		guard let contactCard=context as? ContactCardMO else {
			return
		}
		contactCardMO=contactCard
		guard let imageData=contactCard.qrCodeImage else {
			return
		}
		image.setImage(UIImage(data: imageData)?.withRenderingMode(.alwaysTemplate))
		let colorModel=ColorModel()
		let color=colorModel.getColorsDictionary()[contactCardMO?.color ?? "Contrasting Color"] ?? UIColor.white
		image.setTintColor(color)
    }
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
	override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
		return contactCardMO
	}
}
