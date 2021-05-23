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
	let container=loadPersistentContainer()
	var fetchedResultsController: NSFetchedResultsController<ContactCardMO>?
	override func awake(withContext context: Any?) {
		// Configure interface objects here.
		print("Choose Card Controller awoke")
		NotificationCenter.default.addObserver(self, selector: #selector(loadTable), name: .NSPersistentStoreRemoteChange, object: nil)
	}
	override func willActivate() {
		let contactCardFetchRequest = NSFetchRequest<ContactCardMO>(entityName: "ContactCard")
				let sortDescriptor = NSSortDescriptor(key: "filename", ascending: true)
		contactCardFetchRequest.sortDescriptors = [sortDescriptor]
		let context=container.viewContext

				self.fetchedResultsController = NSFetchedResultsController<ContactCardMO>(
					fetchRequest: contactCardFetchRequest,
					managedObjectContext: context,
					sectionNameKeyPath: nil,
					cacheName: nil)
		self.fetchedResultsController?.delegate = self
		do {
			try fetchedResultsController?.performFetch()
			loadTable()
			print("performed fetch")
			} catch {
				print("error performing fetch \(error.localizedDescription)")
			}
	}
	override func didDeactivate() {
		// This method is called when watch view controller is no longer visible
	}
	@objc func loadTable() {
		guard let sections = fetchedResultsController?.sections else {
			return
		}
		let currentSection = sections[0]
		table.setNumberOfRows(currentSection.numberOfObjects, withRowType: "ContactTitleRow")
		for index in 0..<currentSection.numberOfObjects {
			guard let row = table.rowController(at: index) as? ContactTitleRowController else {
				continue
			}
			let contactCardMO=fetchedResultsController?.object(at: IndexPath(row: index, section: 0))
			row.titleLabel.setTextColor(colorModel.getColorsDictionary()[contactCardMO?.color ?? "Contrasting Color"] ?? UIColor.black)
			row.titleLabel.setText(contactCardMO?.filename)
		}
	}
	override func contextForSegue(withIdentifier segueIdentifier: String,
					  in table: WKInterfaceTable,
					  rowIndex: Int) -> Any? {
		return fetchedResultsController?.object(at:IndexPath(row: rowIndex, section: 0))
	}
}
