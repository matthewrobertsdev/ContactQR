//
//  ContactCardTableViewController.swift
//  Air Contacts
//
//  Created by Matt Roberts on 11/12/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import UIKit
class ContactCardsTableViewController: UITableViewController {
	@IBOutlet weak var editButton: UIBarButtonItem!
	var selectedCardUUID: String?
	let colorModel=ColorModel()
    override func viewDidLoad() {
        super.viewDidLoad()
		if let splitViewController=splitViewController {
			splitViewController.primaryBackgroundStyle = .sidebar
		}
		self.navigationController?.setToolbarHidden(false, animated: true)
		stopEditingIfNoContactCards()
		#if targetEnvironment(macCatalyst)
		tableView.dragDelegate = self
		tableView.dragInteractionEnabled = true
		#endif
		let notificationCenter=NotificationCenter.default
		notificationCenter.addObserver(self, selector: #selector(handleNewContact), name: .contactCreated, object: nil)
		notificationCenter.addObserver(self, selector: #selector(removeContact), name: .contactDeleted, object: nil)
		notificationCenter.addObserver(self, selector: #selector(reloadWithUUID), name: .contactUpdated, object: nil)
    }
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		#if targetEnvironment(macCatalyst)
			navigationController?.setNavigationBarHidden(true, animated: animated)
			navigationController?.setToolbarHidden(true, animated: animated)
		#endif
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
		let lastRowNumber=ContactCardStore.sharedInstance.contactCards.count-1
		let indexPath=IndexPath(row: lastRowNumber, section: 0)
		#if targetEnvironment(macCatalyst)
			tableView.reloadData()
		#else
		tableView.insertRows(at: [indexPath], with: .bottom)
		#endif
		tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
		selectedCardUUID=ContactCardStore.sharedInstance.contactCards.last?.uuidString
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
			ActiveContactCard.shared.contactCard=ContactCardStore.sharedInstance.contactCards[indexPath.row]
			NotificationCenter.default.post(name: .contactChanged, object: nil)
			splitViewController.show(.secondary)
	}
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ContactCardStore.sharedInstance.contactCards.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell=tableView.dequeueReusableCell(withIdentifier: "SavedContactCell", for: indexPath)
				as? SavedContactCell else {
			return UITableViewCell()
		}
		cell.nameLabel.text=ContactCardStore.sharedInstance.contactCards[indexPath.row].filename
		let colorString=ContactCardStore.sharedInstance.contactCards[indexPath.row].color
		if let color=colorModel.colorsDictionary[colorString] as? UIColor {
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
		let currentUUID=ContactCardStore.sharedInstance.contactCards[indexPath.row].uuidString
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
	override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		let contactCardToMove = ContactCardStore.sharedInstance.contactCards.remove(at: sourceIndexPath.row)
		ContactCardStore.sharedInstance.contactCards.insert(contactCardToMove, at: destinationIndexPath.row)
		ContactCardStore.sharedInstance.saveContacts()
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
						 attributes: [], state: .on),
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
			ContactCardStore.sharedInstance.contactCards.remove(at: indexPath.row)
			ContactCardStore.sharedInstance.saveContacts()
            tableView.deleteRows(at: [indexPath], with: .fade)
			stopEditingIfNoContactCards()
			NotificationCenter.default.post(name: .contactDeleted, object: nil)
			if !ContactCardStore.sharedInstance.contactCards.contains(where: { (contactCard) -> Bool in
				contactCard.uuidString==ActiveContactCard.shared.contactCard?.uuidString
			}) {
				ActiveContactCard.shared.contactCard=nil
				NotificationCenter.default.post(name: .contactDeleted, object: nil)
			}
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
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
    }
    */
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
	//*
}
#if targetEnvironment(macCatalyst)
extension ContactCardsTableViewController: UITableViewDragDelegate {
	func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
		let dragItem = UIDragItem(itemProvider: NSItemProvider())
		dragItem.localObject = ContactCardStore.sharedInstance.contactCards[indexPath.row]
			return [ dragItem ]
	}
}
#endif