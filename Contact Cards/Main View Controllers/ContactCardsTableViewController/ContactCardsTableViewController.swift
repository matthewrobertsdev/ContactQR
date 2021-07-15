//
//  ContactCardTableViewController.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/12/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import UIKit
import CoreData
//MARK: View Controller
class ContactCardsTableViewController: UITableViewController {
	//for deleting cards
	@IBOutlet weak var editButton: UIBarButtonItem!
	//for configuring siri
	@IBOutlet weak var siriButton: UIBarButtonItem!
	//for keeping table view up to date
	var fetchedResultsController: NSFetchedResultsController<ContactCardMO>?
	//for colors
	let colorModel=ColorModel()
	//main core data context for the main app
	let managedObjectContext=(UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
	//set-up table view with data
	override func viewDidLoad() {
		super.viewDidLoad()
		//show toolbar
		self.navigationController?.setToolbarHidden(false, animated: false)
		//sidebar for mac catalyst and iPad
		if let splitViewController=splitViewController {
			splitViewController.primaryBackgroundStyle = .sidebar
		}
		let notificationCenter=NotificationCenter.default
		//should push new contact
		notificationCenter.addObserver(self, selector: #selector(handleNewContact), name: .contactCreated, object: nil)
		//literally deletes every card
		notificationCenter.addObserver(self, selector: #selector(deleteAllCards), name: .deleteAllCards, object: nil)
		//updates table view on return to app
		notificationCenter.addObserver(self, selector: #selector(updateContent), name: UIApplication.willEnterForegroundNotification, object: nil)
		//notificationCenter.addObserver(self, selector: #selector(updateContent), name: .cardsLoaded, object: nil)
		let keyValueStore=NSUbiquitousKeyValueStore.default
		if !keyValueStore.bool(forKey: "hasAskedToSync") {
			let syncMessage="Do you want to sync contact cards created with this app with iCloud?  You can change this setting with the \"Manage Data\" button that looks like a gear."
			let syncAlertController=UIAlertController(title: "Sync contact cards with iCloud?", message: syncMessage, preferredStyle: .alert)
			guard let container=(UIApplication.shared.delegate as? AppDelegate)?.persistentContainer else {
				return
			}
			syncAlertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { alertAction in
				keyValueStore.set(true, forKey: "iCloudSync")
				keyValueStore.synchronize()
				updatePersistentContainer(container: container, neverSync: false)
				keyValueStore.set(true, forKey: "hasAskedToSync")
			}))
			syncAlertController.addAction(UIAlertAction(title: "No", style: .default, handler: { alertAction in
				keyValueStore.set(false, forKey: "iCloudSync")
				keyValueStore.synchronize()
				updatePersistentContainer(container: container, neverSync: false)
				keyValueStore.set(true, forKey: "hasAskedToSync")
			}))
			present(syncAlertController, animated: true)
		}
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		//hide navigation bar and iOS toolbar for catalyst
		#if targetEnvironment(macCatalyst)
		navigationController?.setNavigationBarHidden(true, animated: animated)
		navigationController?.setToolbarHidden(true, animated: animated)
		#endif
		//get tableview and fetched resulst controller up to date
		updateContent()
	}
	//get tableview and fetched result controller up to date
	@objc func updateContent() {
		//make fech for all ContactCard entities
		let contactCardFetchRequest = NSFetchRequest<ContactCardMO>(entityName: "ContactCard")
		//sort alphabetically
		contactCardFetchRequest.sortDescriptors = [NSSortDescriptor(key: "filename", ascending: true)]
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
 		} catch {
			print("error performing fetch \(error.localizedDescription)")
		}
		tableView.reloadData()
		handleSelection()
	}
	func handleSelection() {
		if let selectedContactCard=ActiveContactCard.shared.contactCard {
			if let row=fetchedResultsController?.fetchedObjects?.firstIndex(of: selectedContactCard) {
				tableView.selectRow(at: IndexPath(row: row, section: 0), animated: true, scrollPosition: .middle)
			}
		}
		//deselect if it is collapsed on reapppear
		guard let selectedIndexPath=tableView.indexPathForSelectedRow else {
			return
		}
		guard let splitViewController=splitViewController else {
			return
		}
		if splitViewController.isCollapsed {
			tableView.deselectRow(at: selectedIndexPath, animated: false)
		}
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		stopEditing()
	}
	override var canBecomeFirstResponder: Bool {
		return true
	}
	@objc func handleNewContact() {
		guard let splitViewController=splitViewController else {
			return
		}
		if let indexPath=tableView.indexPathForSelectedRow {
			tableView.deselectRow(at: indexPath, animated: true)
		}
		if let contactCard=ActiveContactCard.shared.contactCard {
			if let row=fetchedResultsController?.fetchedObjects?.firstIndex(of: contactCard) {
				tableView.selectRow(at: IndexPath(row: row, section: 0), animated: true, scrollPosition: .middle)
			}
		}
		stopEditing()
		editButton.isEnabled=true
		NotificationCenter.default.post(name: .contactChanged, object: nil)
		splitViewController.show(.secondary)
	}
	func showContactCard() {
		guard let splitViewController=splitViewController else {
			return
		}
		guard let indexPath=tableView.indexPathForSelectedRow else {
			return
		}
		ActiveContactCard.shared.contactCard=fetchedResultsController?.object(at: indexPath)
		NotificationCenter.default.post(name: .contactChanged, object: nil)
		splitViewController.show(.secondary)
	}
	@IBAction func createContactCardFromContact(_ sender: Any) {
		self.present(PickContactViewController(), animated: true)
	}
	@objc func createNewContact() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		guard let createContactViewController=storyboard.instantiateViewController(withIdentifier:
																					"CreateContactViewController") as? CreateContactViewController else {
			print("Failed to instantiate CreateContactViewController")
			return
		}
		let navigationController=UINavigationController(rootViewController: createContactViewController)
		present(navigationController, animated: true)
	}
	func selectFirstContact() {
		if let sections = fetchedResultsController?.sections {
			let currentSection = sections[0]
			if currentSection.numberOfObjects>0 {
				tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .middle)
				showContactCard()
			}
		}
	}
	@objc func goUpOne() {
		guard let indexPath=tableView.indexPathForSelectedRow else {
			selectFirstContact()
			return
		}
		if indexPath.row>0 {
			tableView.selectRow(at: IndexPath(row: indexPath.row-1, section: 0), animated: true, scrollPosition: .middle)
			showContactCard()
		}
	}
	@objc func goDownOne() {
		guard let indexPath=tableView.indexPathForSelectedRow else {
			selectFirstContact()
			return
		}
		if let sections = fetchedResultsController?.sections {
			let currentSection = sections[0]
			if indexPath.row<currentSection.numberOfObjects-1 {
				tableView.selectRow(at: IndexPath(row: indexPath.row+1, section: 0), animated: true, scrollPosition: .middle)
				showContactCard()
			}
		}
	}
	@IBAction func toggleEditing(_ sender: Any) {
		if tableView.isEditing {
			stopEditing()
		} else {
			tableView.setEditing(true, animated: true)
			editButton.title="Done"
		}
	}
	func stopEditing() {
		tableView.setEditing(false, animated: true)
		editButton.title="Edit"
	}
	func stopEditingIfNoContactCards() {
		if let sections = fetchedResultsController?.sections {
			let currentSection = sections[0]
			if currentSection.numberOfObjects==0 {
				tableView.setEditing(false, animated: true)
				editButton.title="Edit"
				editButton.isEnabled=false
			}
		}
	}
	@objc func deleteAllCards() {
		guard let managedObjectContext=managedObjectContext else {
			return
		}
		// Initialize Fetch Request
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ContactCard")
		// Configure Fetch Request
		fetchRequest.includesPropertyValues = false
		do {
			guard let items = try managedObjectContext.fetch(fetchRequest) as? [NSManagedObject] else {
				return
			}
			for item in items {
				managedObjectContext.delete(item)
			}
			//updateContent()
			// Save Changes
			try managedObjectContext.save()
			let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

			if var topController = keyWindow?.rootViewController {
				while let presentedViewController = topController.presentedViewController {
					topController = presentedViewController
				}
				let successAlertViewController=UIAlertController(title: "Records deleted", message: "All records were successfully deleted.", preferredStyle: .alert)
				let gotItAction=UIAlertAction(title: "Got it.", style: .default, handler: { _ in
					successAlertViewController.dismiss(animated: true)
				})
				successAlertViewController.addAction(gotItAction)
				successAlertViewController.preferredAction=gotItAction
				UserDefaults(suiteName: "group.com.apps.celeritas.contact.cards")?.setValue(UUID().uuidString, forKey: "lastUpdateUUID")
				topController.present(successAlertViewController, animated: true)
			}
		} catch {
			// Error Handling
		}
	}
}
