//
//  ChooseCardViewController.swift
//  Contact Cards
//
//  Created by Matt Roberts on 5/12/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import UIKit
import CoreData
class ChooseCardViewController: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate {
	@IBOutlet weak var stackView: UIStackView!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
	let colorModel=ColorModel()
	var fetchedResultsController: NSFetchedResultsController<ContactCardMO>?
	let managedObjectContext=(UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
	var forWatch=true
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.dataSource=self
		tableView.delegate=self
        // Do any additional setup after loading the view.
    }
	override func viewWillAppear(_ animated: Bool) {
		let contactCardFetchRequest = NSFetchRequest<ContactCardMO>(entityName: "ContactCard")
				let sortDescriptor = NSSortDescriptor(key: "filename", ascending: true)
		contactCardFetchRequest.sortDescriptors = [sortDescriptor]
		guard let context=managedObjectContext else {
			return
		}

				self.fetchedResultsController = NSFetchedResultsController<ContactCardMO>(
					fetchRequest: contactCardFetchRequest,
					managedObjectContext: context,
					sectionNameKeyPath: nil,
					cacheName: nil)
		self.fetchedResultsController?.delegate = self
		do {
			try fetchedResultsController?.performFetch()
			print("performed fetch")
			} catch {
				print("error performing fetch \(error.localizedDescription)")
			}
	}
	@IBAction func cancel(_ sender: Any) {
		navigationController?.dismiss(animated: true)
	}
	// MARK: - Table view data source
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let sections = fetchedResultsController?.sections {
			let currentSection = sections[section]
			print(currentSection.numberOfObjects)
			return currentSection.numberOfObjects
		}
		return 0
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell=tableView.dequeueReusableCell(withIdentifier: "SavedContactCell", for: indexPath)
				as? SavedContactCell else {
			return UITableViewCell()
		}
		guard let contactCard = fetchedResultsController?.object(at: indexPath) else {
			return UITableViewCell()
		}
		print("abcd\(contactCard.description)")
		cell.nameLabel.text=contactCard.filename
		let colorString=contactCard.color
		if let color=colorModel.getColorsDictionary()[colorString] as? UIColor {
			cell.circularColorView.backgroundColor=color
		}
		return cell
	}
	override var canBecomeFirstResponder: Bool {
		return true
	}
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
			self.tableView.beginUpdates()
		}
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		self.tableView.endUpdates()

	}
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
					didChange anObject: Any,
					at indexPath: IndexPath?,
					for type: NSFetchedResultsChangeType,
					newIndexPath: IndexPath?) {
		let animation=UITableView.RowAnimation.fade
			switch type {
			case .insert:
				if let insertIndexPath = newIndexPath {
					self.tableView.insertRows(at: [insertIndexPath], with: animation)
				}
			case .delete:
				if let deleteIndexPath = indexPath {
					self.tableView.deleteRows(at: [deleteIndexPath], with: animation)
				}
			case .update:
				if let updateIndexPath = indexPath {
					tableView.reloadRows(at: [updateIndexPath], with: animation)
				}
			case .move:
				if let deleteIndexPath = indexPath {
					self.tableView.deleteRows(at: [deleteIndexPath], with: animation)
				}
				if let insertIndexPath = newIndexPath {
					self.tableView.insertRows(at: [insertIndexPath], with: animation)
				}
			default:
				break
			}
		}
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
					didChange sectionInfo: NSFetchedResultsSectionInfo,
					atSectionIndex sectionIndex: Int,
					for type: NSFetchedResultsChangeType) {
			let sectionIndexSet = NSIndexSet(index: sectionIndex) as IndexSet
		let animation=UITableView.RowAnimation.fade
			switch type {
			case .insert:
				self.tableView.insertSections(sectionIndexSet, with: animation)
			case .delete:
				self.tableView.deleteSections(sectionIndexSet, with: animation)
			default:
				break
			}
		}
	func tableView(_ tableView: UITableView,
							didSelectRowAt indexPath: IndexPath) {
		doneBarButtonItem.isEnabled=true
	}
	@IBAction func done(_ sender: Any) {
		guard let controller=fetchedResultsController else {
			return
		}
		if let indexPath=tableView.indexPathForSelectedRow {
			let contactCardMO=controller.object(at: indexPath)
			UserDefaults(suiteName: "group.com.apps.celeritas.contact.cards")?.set(contactCardMO.color, forKey: "chosenCardColor")
			UserDefaults(suiteName: "group.com.apps.celeritas.contact.cards")?.set(contactCardMO.qrCodeImage, forKey: "chosenCardImageData")
			UserDefaults(suiteName: "group.com.apps.celeritas.contact.cards")?.set(contactCardMO.objectID.uriRepresentation().absoluteString, forKey: "chosenCardObjectID")
			UserDefaults(suiteName: "group.com.apps.celeritas.contact.cards")?.set(contactCardMO.filename, forKey: "chosenCardTitle")
			NotificationCenter.default.post(name: .siriCardChosen, object: nil)
			navigationController?.dismiss(animated: true)
		}
	}
	/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
