//
//  ContactCardTableViewController.swift
//  Air Contacts
//
//  Created by Matt Roberts on 11/12/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import UIKit
import CoreData
class ContactCardsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
	@IBOutlet weak var editButton: UIBarButtonItem!
	var fetchedResultsController: NSFetchedResultsController<ContactCardMO>?
	var selectedCardUUID: String?
	static let selectedCardUUIDKey="selectedCardUUID"
	let colorModel=ColorModel()
	let managedObjectContext=(UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
	override func viewDidLoad() {
		super.viewDidLoad()
		#if targetEnvironment(macCatalyst)
		
		#endif
		/*
		let fetchRequest = NSFetchRequest<ContactCardMO>(entityName: ContactCardMO.entityName)
		do {
		let contactCards = try managedObjectContext?.fetch(fetchRequest)
		} catch {
			print("ERROR")
		}
*/
		if let splitViewController=splitViewController {
			splitViewController.primaryBackgroundStyle = .sidebar
		}
		self.navigationController?.setToolbarHidden(false, animated: false)
		stopEditingIfNoContactCards()
		/*
		#if targetEnvironment(macCatalyst)
		tableView.dragDelegate = self
		tableView.dragInteractionEnabled = true
		#endif
*/
		let notificationCenter=NotificationCenter.default
		notificationCenter.addObserver(self, selector: #selector(handleNewContact), name: .contactCreated, object: nil)
		notificationCenter.addObserver(self, selector: #selector(removeContact), name: .contactDeleted, object: nil)
		notificationCenter.addObserver(self, selector: #selector(reloadWithUUID), name: .contactUpdated, object: nil)
		/*
		#if targetEnvironment(macCatalyst)
		if let selectedCardUUID=UserDefaults.standard.string(forKey: ContactCardsTableViewController.selectedCardUUIDKey) {
			self.selectedCardUUID=selectedCardUUID
			if let index=ContactCardStore.sharedInstance.getIndexOfContactWithUUID(uuid: selectedCardUUID) {
				//tableView.selectRow(at: IndexPath(row: index, section: 0), animated: false, scrollPosition: .middle)
				showContactCard()
				SceneDelegate.enableValidToolbarItems()
			}
		}
		#endif
*/
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		#if targetEnvironment(macCatalyst)
		navigationController?.setNavigationBarHidden(true, animated: animated)
		navigationController?.setToolbarHidden(true, animated: animated)
		#endif
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
	@objc func reloadWithUUID(notification: NSNotification) {
		guard let userInfo = notification.userInfo as? [String: Any] else {
			return
		}
		guard let uuid=userInfo["uuid"] as? String else {
			return
		}
		let index=ContactCardStore.sharedInstance.contactCards.firstIndex { (contactCard) -> Bool in
			return contactCard.uuidString==uuid
		}
		if let index=index {
			let indexPath=IndexPath(row: index, section: 0)
			tableView.reloadData()
			tableView.selectRow(at: indexPath, animated: false, scrollPosition: .middle)
		}
	}
	@objc func handleNewContact() {
		showContactCard()
		stopEditing()
		editButton.isEnabled=true
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
	func showContactCard() {
		guard let splitViewController=splitViewController else {
			return
		}
		guard let indexPath=tableView.indexPathForSelectedRow else {
			return
		}
		ActiveContactCard.shared.contactCard=fetchedResultsController?.object(at: indexPath)
		#if targetEnvironment(macCatalyst)
		UserDefaults.standard.setValue(selectedCardUUID, forKey: ContactCardsTableViewController.selectedCardUUIDKey)
		#endif
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
			print(currentSection.numberOfObjects)
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
		print("abcd\(contactCard.description)")
		cell.nameLabel.text=contactCard.filename
		let colorString=contactCard.color
		if let color=colorModel.colorsDictionary[colorString ?? "Contrasting Color"] as? UIColor {
			cell.circularColorView.backgroundColor=color
		}
		return cell
	}
	@IBAction func createContactCardFromContact(_ sender: Any) {
		var animated=true
		#if targetEnvironment(macCatalyst)
		animated=false
		#endif
		self.present(PickContactViewController(), animated: animated) {
		}
	}
	override func tableView(_ tableView: UITableView,
							didSelectRowAt indexPath: IndexPath) {
		guard let splitViewController=splitViewController else {
			return
		}
		let currentUUID=fetchedResultsController?.object(at: indexPath).objectID.uriRepresentation().absoluteString
		if splitViewController.isCollapsed || selectedCardUUID != currentUUID {
			selectedCardUUID=currentUUID
			showContactCard()
		}
	}
	@objc func createNewContact() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		guard let createContactViewController=storyboard.instantiateViewController(withIdentifier:
																					"CreateContactViewController") as? CreateContactViewController else {
			print("Failed to instantiate CreateContactViewController")
			return
		}
		let navigationController=UINavigationController(rootViewController: createContactViewController)
		var animated=true
		#if targetEnvironment(macCatalyst)
		animated=false
		#endif
		present(navigationController, animated: animated)
	}
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		#if targetEnvironment(macCatalyst)
		UIView.setAnimationsEnabled(false)
		#endif
			self.tableView.beginUpdates()
		}
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		self.tableView.endUpdates()
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
				if let insertIndexPath = newIndexPath {
					self.tableView.insertRows(at: [insertIndexPath], with: animation)
				}
			case .delete:
				if let deleteIndexPath = indexPath {
					self.tableView.deleteRows(at: [deleteIndexPath], with: animation)
				}
			case .update:
				if let updateIndexPath = indexPath {
					guard let cell = self.tableView.cellForRow(at: updateIndexPath) as? SavedContactCell else {
						return
					}
					guard let contactCard = fetchedResultsController?.object(at: updateIndexPath) else {
						return
					}
					cell.nameLabel.text=contactCard.filename
					let colorString=contactCard.color
					if let color=colorModel.colorsDictionary[colorString ?? "Contrasting Color"] as? UIColor {
						cell.circularColorView.backgroundColor=color
					}
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
	func selectFirstContact() {
		if ContactCardStore.sharedInstance.contactCards.count>0 {
			tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .middle)
		}
		showContactCard()
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
		if indexPath.row<ContactCardStore.sharedInstance.contactCards.count-1 {
			tableView.selectRow(at: IndexPath(row: indexPath.row+1, section: 0), animated: true, scrollPosition: .middle)
			showContactCard()
		}
	}
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		if tableView.isEditing {
			return true
		}
		return false
	}
	override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		return .delete
	}
	/*
	override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		let contactCardToMove = ContactCardStore.sharedInstance.contactCards.remove(at: sourceIndexPath.row)
		ContactCardStore.sharedInstance.contactCards.insert(contactCardToMove, at: destinationIndexPath.row)
		ContactCardStore.sharedInstance.saveContacts()
	}
*/
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
	/*
	// Override to support conditional editing of the table view.
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
	// Return false if you do not want the specified item to be editable.
	return true
	}
	*/
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
							forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			// Delete the row from the data source
			//ContactCardStore.sharedInstance.contactCards.remove(at: indexPath.row)
			//ContactCardStore.sharedInstance.saveContacts()
			guard let resultsController=fetchedResultsController else {
				return
			}
			let contactCard = resultsController.object(at: indexPath)
			managedObjectContext?.delete(contactCard)
			stopEditingIfNoContactCards()
			NotificationCenter.default.post(name: .contactDeleted, object: nil)
			/*
			if !ContactCardStore.sharedInstance.contactCards.contains(where: { (contactCard) -> Bool in
				contactCard.uuidString==ActiveContactCard.shared.contactCard?.uuidString
			}) {
				ActiveContactCard.shared.contactCard=nil
				NotificationCenter.default.post(name: .contactDeleted, object: nil)
			}
*/
		}
	}
	func stopEditingIfNoContactCards() {
		if ContactCardStore.sharedInstance.contactCards.count==0 {
			tableView.setEditing(false, animated: true)
			editButton.title="Edit"
			editButton.isEnabled=false
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
