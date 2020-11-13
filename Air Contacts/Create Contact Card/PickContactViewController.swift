//
//  PickContactDelegate.swift
//  CardQR
//
//  Created by Matt Roberts on 12/18/18.
//  Copyright © 2018 Matt Roberts. All rights reserved.
//
import ContactsUI
/*
 A CNContactPickerViewController subclassed to be a delgate that
 assigns a chosen contact to ActiveContact.shared.activeContact
 */
class PickContactViewController: CNContactPickerViewController, CNContactPickerDelegate {
	var picked=false
    //set as CNContactPickerDelegate
    override func viewDidLoad() {
        delegate=self
    }
    /*
    delegate function.  Assigns to ActiveContact shared singleton object
    and posts notification so observing classes can get notificiation
     */
    func contactPicker(_ picker: CNContactPickerViewController,
                       didSelect contact: CNContact) {
		if (picked==false) {
			ActiveContact.shared.contact=contact
			NotificationCenter.default.post(name: .contactPicked, object: self, userInfo: ["animated": false])
		}
    }
}

extension Notification.Name {
	//Reference as .contactChanged when type inference is possible
	static let contactPicked=Notification.Name("contact-picked")
}
