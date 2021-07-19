//
//  ChooseCardController.swift
//  ContactCardsWatch Extension
//
//  Created by Matt Roberts on 5/21/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import WatchKit
import CoreData
class ChooseCardController: WKInterfaceController, NSFetchedResultsControllerDelegate {
	@IBOutlet weak var noCardsLabel: WKInterfaceLabel!
	@IBOutlet weak var chooseCardLabel: WKInterfaceLabel!
	@IBOutlet weak var table: WKInterfaceTable!
	let colorModel=ColorModel()
	override func awake(withContext context: Any?) {
		// Configure interface objects here.
		super.willActivate()
	}
	override func willActivate() {
		updateData()
		loadTable()
	}
	override func didDeactivate() {
		super.didDeactivate()
		// This method is called when watch view controller is no longer visible
	}
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		loadTable()
	}
	@objc func updateData() {
		ContactCardStore.shared.loadCards(delegate: self)
	}
	@objc func loadTable() {
		guard let sections = ContactCardStore.shared.fetchedResultsController?.sections else {
			noCardsLabel.setHidden(false)
			chooseCardLabel.setHidden(true)
			return
		}
		let currentSection = sections[0]
		if currentSection.numberOfObjects>0 {
			noCardsLabel.setHidden(true)
			chooseCardLabel.setHidden(false)
		} else {
			noCardsLabel.setHidden(false)
			chooseCardLabel.setHidden(true)
		}
		table.setNumberOfRows(currentSection.numberOfObjects, withRowType: "ContactTitleRow")
		for index in 0..<currentSection.numberOfObjects {
			guard let row = table.rowController(at: index) as? ContactTitleRowController else {
				continue
			}
			let contactCardMO=ContactCardStore.shared.fetchedResultsController?.object(at: IndexPath(row: index, section: 0))
			row.titleLabel.setTextColor(colorModel.getColorsDictionary()[contactCardMO?.color ?? "Contrasting Color"] ?? UIColor.black)
			row.titleLabel.setText(contactCardMO?.filename)
		}
	}
	override func contextForSegue(withIdentifier segueIdentifier: String,
					  in table: WKInterfaceTable,
					  rowIndex: Int) -> Any? {
		ActiveContactCard.shared.contactCard=ContactCardStore.shared.fetchedResultsController?.object(at: IndexPath(row: rowIndex, section: 0))
		return nil
	}
}
extension Notification.Name {
	static let contactChanged=Notification.Name("contact-changed")
}
