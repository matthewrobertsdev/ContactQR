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
	let model=WatchContactStore.sharedInstance
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
		NotificationCenter.default.addObserver(self, selector: #selector(updateUIForContactChanged), name: .watchContactUpdated, object: nil)
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
	@objc func updateUIForContactChanged() {
		guard let cardString=model.getCardString() else {
			return
		}
		guard let title=model.getTitle() else {
			return
		}
		cardDetailsLabel.setAttributedText(cardString)
		cardTitleLabel.setText(title)
		cardTitleLabel.setTextColor(model.getColor())
	}
}
