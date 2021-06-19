//
//  ChooseColorTableViewController.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/24/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import UIKit
import Contacts
import WidgetKit
class ChooseColorTableViewController: UITableViewController {
	@IBOutlet weak var nextButton: UIBarButtonItem!
	let model=ColorModel()
	var forEditing=false
	var contact=CNContact()
	var contactCard: ContactCardMO?
    override func viewDidLoad() {
        super.viewDidLoad()
		nextButton.isEnabled=false
		tableView.selectionFollowsFocus=true
		if forEditing {
			navigationItem.leftBarButtonItem?.title="Save"
		}
    }
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		AppState.shared.appState=AppStateValue.isModal
		NotificationCenter.default.post(name: .modalityChanged, object: nil)
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		AppState.shared.appState=AppStateValue.isNotModal
		NotificationCenter.default.post(name: .modalityChanged, object: nil)
	}
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
		return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return model.colors.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell=tableView.dequeueReusableCell(withIdentifier:
														"SavedContactCell", for: indexPath) as? SavedContactCell else {
			return UITableViewCell()
		}
		cell.circularColorView.backgroundColor=model.colors[indexPath.row].color
		cell.nameLabel.text=model.colors[indexPath.row].name
		return cell
    }
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		nextButton.isEnabled=true
	}
	@IBAction func next(_ sender: Any) {
		guard let indexPath=tableView.indexPathForSelectedRow else {
			return
		}
		if forEditing {
			contactCard?.color=model.colors[indexPath.row].name
			let managedObjectContext=(UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
			do {
				try managedObjectContext?.save()
				UserDefaults(suiteName: "group.com.apps.celeritas.contact.cards")?.setValue(UUID().uuidString, forKey: "lastUpdateUUID")
			} catch {
				print("Couldn't save color")
			}
			updateWidget(contactCard: self.contactCard)
			NotificationCenter.default.post(name: .contactUpdated, object: self, userInfo: ["uuid": self.contactCard?.objectID.uriRepresentation().absoluteString ?? ""])
			navigationController?.dismiss(animated: true)
		}
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		guard let saveContactCardViewController=storyboard.instantiateViewController(withIdentifier:
																						"SaveContactCardViewController")
				as? SaveContactCardViewController else {
			print("Failed to instantiate SaveContactCardViewController")
			return
		}
		saveContactCardViewController.contact=contact
		saveContactCardViewController.color=model.colors[indexPath.row].name
		navigationController?.pushViewController(saveContactCardViewController, animated: true)
	}
	@IBAction func cancel(_ sender: Any) {
		navigationController?.dismiss(animated: true)
	}
	override var canBecomeFirstResponder: Bool {
		return true
	}
	override var keyCommands: [UIKeyCommand]? {
		return [UIKeyCommand(title: "Close", image: nil, action: #selector(cancel(_:)), input: UIKeyCommand.inputEscape,
							 modifierFlags: .command, propertyList: nil, alternates: [], discoverabilityTitle: "Close",
							 attributes: .destructive, state: .on)]
	}
}
