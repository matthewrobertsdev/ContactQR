//
//  CardInterfaceController.swift
//  ContactCardsWatch Extension
//
//  Created by Matt Roberts on 5/15/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import WatchKit
import Foundation
import CoreData
class CardInterfaceController: WKInterfaceController, NSFetchedResultsControllerDelegate {
	@IBOutlet weak var cardDeletedLabel: WKInterfaceLabel!
	@IBOutlet weak var cardTitleLabel: WKInterfaceLabel!
	@IBOutlet weak var cardDetailsLabel: WKInterfaceLabel!
	override func awake(withContext context: Any?) {
		super.awake(withContext: context)
		// Configure interface objects here.
	}
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		updateScreen()
	}
	func updateContact() {
		ContactCardStore.shared.assignActiveContact()
	}
	@objc func loadView() {
		guard let contactCard=ActiveContactCard.shared.contactCard else {
			cardDeletedLabel.setHidden(false)
			cardTitleLabel.setHidden(true)
			cardDetailsLabel.setHidden(true)
			return
		}
		cardDeletedLabel.setHidden(true)
		cardTitleLabel.setHidden(false)
		cardDetailsLabel.setHidden(false)
		do {
			let contact=try ContactDataConverter.createCNContactArray(vCardString: contactCard.vCardString)[0]
			let cardString=ContactInfoManipulator.makeContactDisplayString(cnContact: contact, fontSize: CGFloat(13))
			cardDetailsLabel.setAttributedText(cardString)
			cardTitleLabel.setText(contactCard.filename)
			let colorModel=ColorModel()
			let color=colorModel.getColorsDictionary()[contactCard.color] ?? UIColor.white
			cardTitleLabel.setTextColor(color)
		} catch {
			print("Unable to create contact from vCard for watch.")
		}
	}
	override func willActivate() {
		// This method is called when watch view controller is about to be visible to user
		super.willActivate()
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
		// This method is called when watch view controller is no longer visible
		super.didDeactivate()
	}
}
