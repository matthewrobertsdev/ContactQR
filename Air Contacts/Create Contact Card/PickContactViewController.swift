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
		if picked==false {
			//ActiveContactCard.shared.contact=contact
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			guard let createContactViewController=storyboard.instantiateViewController(withIdentifier: "CreateContactViewController")
					as? CreateContactViewController else {
				print("Failed to instantiate CreateContactViewController")
				return
			}
			createContactViewController.contact=contact
			weak var contactCardTableViewController=presentingViewController
			let navigationController=UINavigationController(rootViewController: createContactViewController)
			dismiss(animated: true) {
				contactCardTableViewController?.present(navigationController, animated: true)
			}
			//NotificationCenter.default.post(name: .contactPicked, object: self, userInfo: ["animated": false])
		}
    }
}

extension Notification.Name {
	//Reference as .contactChanged when type inference is possible
	static let contactPicked=Notification.Name("contact-picked")
}
