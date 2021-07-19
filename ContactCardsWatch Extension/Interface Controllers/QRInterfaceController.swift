//
//  InterfaceController.swift
//  ContactCardsWatch Extension
//
//  Created by Matt Roberts on 4/11/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import WatchKit
import Foundation
import CoreData
class QRInterfaceController: WKInterfaceController, NSFetchedResultsControllerDelegate {
	var contactCardMO: ContactCardMO?
	@IBOutlet weak var showDetailsButton: WKInterfaceButton!
	@IBOutlet weak var contactDeletedLabel: WKInterfaceLabel!
	@IBOutlet weak var image: WKInterfaceImage!
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
    }
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		updateScreen()
	}
	func updateContact() {
		ContactCardStore.shared.assignActiveContact()
	}
	func loadView() {
		guard let contactCard=ActiveContactCard.shared.contactCard else {
			contactDeletedLabel.setHidden(false)
			showDetailsButton.setEnabled(false)
			image.setHidden(true)
			return
		}
		contactDeletedLabel.setHidden(true)
		showDetailsButton.setEnabled(true)
		image.setHidden(false)
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
		super.willActivate()
        // This method is called when watch view controller is about to be visible to user
		updateData()
		updateScreen()
    }
	func updateScreen() {
		updateContact()
		loadView()
	}
	@objc func updateData() {
		ContactCardStore.shared.loadCards(delegate: self)
	}
    override func didDeactivate() {
		super.didDeactivate()
        // This method is called when watch view controller is no longer visible
    }
}
