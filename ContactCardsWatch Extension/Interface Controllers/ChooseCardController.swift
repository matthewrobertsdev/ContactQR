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
	@IBOutlet weak var table: WKInterfaceTable!
	let colorModel=ColorModel()
	override func awake(withContext context: Any?) {
		// Configure interface objects here.
	}
	override func willActivate() {
		super.willActivate()
		NotificationCenter.default.addObserver(self, selector: #selector(loadTable), name: .NSPersistentStoreRemoteChange, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(loadTable), name: .contactChanged, object: nil)
		ContactCardStore.shared.loadCards {
			[weak self] in
			guard let strongSelf=self else {
				return
			}
			strongSelf.loadTable()
		}
	}
	override func didDeactivate() {
		super.didDeactivate()
		// This method is called when watch view controller is no longer visible
	}
	@objc func loadTable() {
		guard let sections = ContactCardStore.shared.fetchedResultsController?.sections else {
			return
		}
		let currentSection = sections[0]
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
