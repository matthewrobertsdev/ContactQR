//
//  ContactCardTableViewController.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/12/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import UIKit
import CoreData
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
		notificationCenter.addObserver(self, selector: #selector(removeContact), name: .contactDeleted, object: nil)
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
	// MARK: - Table view data source
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let sections = fetchedResultsController?.sections {
			let currentSection = sections[section]
			return currentSection.numberOfObjects
		}
		return 0
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell=tableView.dequeueReusableCell(withIdentifier: "SavedContactCell", for: indexPath)
				as? SavedContactCell else {
			return UITableViewCell()
		}
		guard let contactCard = fetchedResultsController?.object(at: indexPath) else {
			return UITableViewCell()
		}
		cell.nameLabel.text=contactCard.filename
		let colorString=contactCard.color
		if let color=colorModel.getColorsDictionary()[colorString] as? UIColor {
			cell.circularColorView.backgroundColor=color
		}
		return cell
	}
	@IBAction func createContactCardFromContact(_ sender: Any) {
		self.present(PickContactViewController(), animated: true)
	}
	override func tableView(_ tableView: UITableView,
							didSelectRowAt indexPath: IndexPath) {
		ActiveContactCard.shared.contactCard=fetchedResultsController?.object(at: indexPath)
		showContactCard()
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
	@objc func removeContact(notification: NSNotification) {
		guard let removalIndex=notification.userInfo?["index"] as? Int else {
			return
		}
		var animation=UITableView.RowAnimation.top
		#if targetEnvironment(macCatalyst)
		animation=UITableView.RowAnimation.none
		#endif
		tableView.deleteRows(at: [IndexPath(row: removalIndex, section: 0)], with: animation)
		stopEditingIfNoContactCards()
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
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		if tableView.isEditing {
			return true
		}
		return false
	}
	override func tableView(_ tableView: UITableView,
							editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		return .delete
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
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
							forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			// Delete the row from the data source
			guard let resultsController=fetchedResultsController else {
				return
			}
			let contactCard = resultsController.object(at: indexPath)
			managedObjectContext?.delete(contactCard)
			do {
			try managedObjectContext?.save()
			stopEditingIfNoContactCards()
			NotificationCenter.default.post(name: .contactDeleted, object: nil)
			} catch {
				print("Error saving deletion")
			}
		}
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
// MARK: FRCDelegate
extension ContactCardsTableViewController: NSFetchedResultsControllerDelegate {
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		//disable animations for catalyst--UITableView animations are buggy
		#if targetEnvironment(macCatalyst)
		UIView.setAnimationsEnabled(false)
		#endif
		self.tableView.beginUpdates()
	}
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		self.tableView.endUpdates()
		if let activeContactCard=ActiveContactCard.shared.contactCard {
			if let contactCard=fetchedResultsController?.fetchedObjects?.first(where: { contactCard in
				contactCard.objectID==activeContactCard.objectID
			}) {
				ActiveContactCard.shared.contactCard=contactCard
			} else {
				ActiveContactCard.shared.contactCard=nil
			}
			NotificationCenter.default.post(name: .contactUpdated, object: nil)
		}
		if let contactCards=fetchedResultsController?.fetchedObjects {
			for contactCard in contactCards {
				updateWidget(contactCard: contactCard)
			}
			let userDefaults=UserDefaults(suiteName: appGroupKey)
			let siriCard=contactCards.first(where: { contactCard in
				contactCard.objectID.uriRepresentation().absoluteURL.absoluteString==userDefaults?.string(forKey: SiriCardKeys.chosenCardObjectID.rawValue)
			})
			updateSiriCard(contactCard: siriCard)
		}
		handleSelection()
		UserDefaults(suiteName: appGroupKey)?.setValue(UUID().uuidString, forKey: "lastUpdateUUID")
		//reanable animations if disabled for catalyst
		#if targetEnvironment(macCatalyst)
		UIView.setAnimationsEnabled(true)
		#endif
	}
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
					didChange anObject: Any,
					at indexPath: IndexPath?,
					for type: NSFetchedResultsChangeType,
					newIndexPath: IndexPath?) {
		var animation=UITableView.RowAnimation.fade
		#if targetEnvironment(macCatalyst)
		animation=UITableView.RowAnimation.none
		#endif
		switch type {
		case .insert:
			if let newIndexPath=newIndexPath {
				self.tableView.insertRows(at: [newIndexPath], with: animation)
			}
		case .delete:
			if let indexPath=indexPath {
				self.tableView.deleteRows(at: [indexPath], with: animation)
			}
		case .update:
			if let indexPath=indexPath {
				tableView.reloadRows(at: [indexPath], with: animation)
			}
		case .move:
			if let indexPath=indexPath {
				self.tableView.deleteRows(at: [indexPath], with: animation)
			}
			if let newIndexPath=newIndexPath {
				self.tableView.insertRows(at: [newIndexPath], with: animation)
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
		var animation=UITableView.RowAnimation.fade
		#if targetEnvironment(macCatalyst)
		animation=UITableView.RowAnimation.none
		#endif
		switch type {
		case .insert:
			self.tableView.insertSections(sectionIndexSet, with: animation)
		case .delete:
			self.tableView.deleteSections(sectionIndexSet, with: animation)
		default:
			break
		}
	}
}
// MARK: Key Coomands
extension ContactCardsTableViewController {
	override var keyCommands: [UIKeyCommand]? {
		if AppState.shared.appState==AppStateValue.isModal {
			return nil
		}
		let keyCommands=[
			UIKeyCommand(title: "Previous Contact", image: nil, action: #selector(goUpOne),
						 input: UIKeyCommand.inputUpArrow, modifierFlags:
							.command, propertyList: nil, alternates: [], discoverabilityTitle: "Previous Contact",
						 attributes: [], state: .on),
			UIKeyCommand(title: "Next Contact", image: nil, action: #selector(goDownOne), input: UIKeyCommand.inputDownArrow,
						 modifierFlags: .command, propertyList: nil, alternates: [], discoverabilityTitle: "Next Contact",
						 attributes: [], state: .on)
		]
		return keyCommands
	}
}
