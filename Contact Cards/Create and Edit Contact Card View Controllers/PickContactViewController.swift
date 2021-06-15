//
//  PickContactDelegate.swift
//  Contact Cards
//
//  Created by Matt Roberts on 12/18/18.
//  Copyright © 2018 Matt Roberts. All rights reserved.
//
import ContactsUI
/*
 A CNContactPickerViewController subclassed to be a delegate that
 assigns a chosen contact to ActiveContact.shared.activeContact
 */
class PickContactViewController: CNContactPickerViewController, CNContactPickerDelegate {
	var picked=false
    //set as CNContactPickerDelegate
    override func viewDidLoad() {
        delegate=self
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
    /*
    delegate function.  Assigns to ActiveContact shared singleton object
    and posts notification so observing classes can get notificiation
     */
    func contactPicker(_ picker: CNContactPickerViewController,
                       didSelect contact: CNContact) {
		if picked==false {
			//ActiveContactCard.shared.contact=contact
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			guard let createContactViewController=storyboard.instantiateViewController(withIdentifier:
																						"CreateContactViewController") as? CreateContactViewController else {
				print("Failed to instantiate CreateContactViewController")
				return
			}
			createContactViewController.contact=contact
			weak var contactCardTableViewController=presentingViewController
			let navigationController=UINavigationController(rootViewController: createContactViewController)
			var animated=true
			#if targetEnvironment(macCatalyst)
				animated=false
			#endif
			dismiss(animated: animated) {
				contactCardTableViewController?.present(navigationController, animated: animated)
			}
		}
    }
}
extension Notification.Name {
	static let contactPicked=Notification.Name("contact-picked")
}
