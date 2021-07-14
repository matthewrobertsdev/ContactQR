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
	var contactPickedHandler = {(contact: CNContact) in }
    //set as CNContactPickerDelegate
    override func viewDidLoad() {
        delegate=self
    }
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		//AppState.shared.appState=AppStateValue.isModal
		//NotificationCenter.default.post(name: .modalityChanged, object: nil)
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		//AppState.shared.appState=AppStateValue.isNotModal
		//NotificationCenter.default.post(name: .modalityChanged, object: nil)
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
			picked=true
			contactPickedHandler(contact)
		}
    }
}
extension Notification.Name {
	static let contactPicked=Notification.Name("contact-picked")
}
