//
//  ContactCardTableViewController.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/12/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import UIKit
import CoreData
// MARK: Table View Controller
class ContactCardsTableViewController: UITableViewController {
	//for deleting cards
	@IBOutlet weak var editButton: UIBarButtonItem!
	//for configuring siri
	@IBOutlet weak var siriButton: UIBarButtonItem!
	//for keeping table view up to date
	var fetchedResultsController: NSFetchedResultsController<ContactCardMO>?
	//for colors
	let colorModel=ColorModel()
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
		notificationCenter.addObserver(self, selector: #selector(updateContent), name: .syncChanged, object: nil)
		tableView.dragDelegate=self
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
		print("Update content")
		//make fech for all ContactCard entities
		let contactCardFetchRequest = NSFetchRequest<ContactCardMO>(entityName: "ContactCard")
		//sort alphabetically
		contactCardFetchRequest.sortDescriptors = [NSSortDescriptor(key: "filename", ascending: true)]
		guard let context=(UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
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
		if let section=fetchedResultsController?.sections?.first {
			print("Test to display add a card alert controller")
			if section.numberOfObjects==0 {
				print("Should display add a card alert controller")
				displayAddACardAlertController()
			}
		}
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
		guard let managedObjectContext=(UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
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
	func displayAddACardAlertController() {
		var addACardMessage=""
		#if targetEnvironment(macCatalyst)
		addACardMessage="To create a contact card, click the plus button in the toolbar or open the File menu and click \"New Contact Card\"."
		#else
		addACardMessage="To create a contact card, tap the plus button."
		#endif
		let addACardAlertController=UIAlertController(title: "Create a Card", message: addACardMessage, preferredStyle: .alert)
		let gotItAction=UIAlertAction(title: "Got it.", style: .default)
		addACardAlertController.addAction(gotItAction)
		addACardAlertController.preferredAction=gotItAction
		splitViewController?.present(addACardAlertController, animated: true)
	}
}
