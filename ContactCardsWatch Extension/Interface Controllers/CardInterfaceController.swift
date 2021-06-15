//
//  CardInterfaceController.swift
//  ContactCardsWatch Extension
//
//  Created by Matt Roberts on 5/15/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import WatchKit
import Foundation
class CardInterfaceController: WKInterfaceController {
	@IBOutlet weak var cardTitleLabel: WKInterfaceLabel!
	@IBOutlet weak var cardDetailsLabel: WKInterfaceLabel!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
		guard let contactCard=context as? ContactCardMO else {
			return
		}
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
        // Configure interface objects here.
    }
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}
