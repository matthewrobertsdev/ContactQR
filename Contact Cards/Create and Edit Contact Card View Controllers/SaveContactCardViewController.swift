//
//  SaveContactCardViewController.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/15/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import UIKit
import Contacts
import WidgetKit
import CoreData
class SaveContactCardViewController: UIViewController, UITextFieldDelegate {
	@IBOutlet weak var saveButton: UIBarButtonItem!
	@IBOutlet weak var titleTextField: UITextField!
	let managedObjectContext=(UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
	var forEditing=false
	var contactCard: ContactCardMO?
	var contact=CNContact()
	var color=ColorChoice.contrastingColor.rawValue
    override func viewDidLoad() {
        super.viewDidLoad()
		if !forEditing {
			saveButton.isEnabled=false
		} else {
			titleTextField.text=contactCard?.filename
		}
		titleTextField.addTarget(self, action: #selector(enableOrDisableSaveButton), for: .editingChanged)
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
	override var canBecomeFirstResponder: Bool {
		return true
	}
	@IBAction func save(_ sender: Any) {
		if forEditing {
			contactCard?.filename=titleTextField.text ?? "No Title Given"
			ActiveContactCard.shared.contactCard=contactCard
			do {
				try managedObjectContext?.save()
				UserDefaults(suiteName: "group.com.apps.celeritas.contact.cards")?.setValue(UUID().uuidString, forKey: "lastUpdateUUID")
			} catch {
				present(localErrorSavingAlertController(), animated: true)
				print("Couldn't save color")
			}
			updateWidget(contactCard: contactCard)
			NotificationCenter.default.post(name: .contactUpdated, object: self, userInfo: ["uuid": self.contactCard?.objectID.uriRepresentation().absoluteString ?? ""])
			navigationController?.dismiss(animated: true)
		} else {
			guard let context=self.managedObjectContext else {
				return
			}
			let contactCard=NSEntityDescription.entity(forEntityName: ContactCardMO.entityName, in: context)
			guard let card=contactCard else {
				return
			}
			let contactCardRecord=ContactCardMO(entity: card, insertInto: context)
			setFields(contactCardMO: contactCardRecord, filename: titleTextField.text ?? "No Title Given", cnContact: contact, color: color)
			do {
				try self.managedObjectContext?.save()
				self.managedObjectContext?.rollback()
			} catch {
				present(localErrorSavingAlertController(), animated: true)
				print(error.localizedDescription)
			}
			navigationController?.dismiss(animated: true, completion: {
			ActiveContactCard.shared.contactCard=contactCardRecord
			NotificationCenter.default.post(name: .contactCreated, object: self, userInfo: nil)
			})
		}
	}
	@IBAction func cancel(_ sender: Any) {
		navigationController?.dismiss(animated: true)
	}
	@objc func enableOrDisableSaveButton() {
		if let text=titleTextField.text {
			if text=="" {
				saveButton.isEnabled=false
			} else {
				saveButton.isEnabled=true
			}
		} else {
			saveButton.isEnabled=false
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
	override var keyCommands: [UIKeyCommand]? {
		return [UIKeyCommand(title: "Close", image: nil, action: #selector(cancel(_:)), input: UIKeyCommand.inputEscape,
							 modifierFlags: .command, propertyList: nil, alternates: [], discoverabilityTitle: "Close",
							 attributes: .destructive, state: .on)]
	}
}
extension Notification.Name {
	static let contactCreated=Notification.Name("contact-created")
	static let contactUpdated=Notification.Name("contact-updated")

}
