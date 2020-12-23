//
//  EditContactAlertController.swift
//  Contact Cards
//
//  Created by Matt Roberts on 12/23/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//

import UIKit
import Contacts

class EditContactAlertController: UIAlertController, UIPopoverControllerDelegate {
	var contact=CNContact()
	var contactCard: ContactCard?
    override func viewDidLoad() {
        super.viewDidLoad()
		addAction(UIAlertAction(title: "Edit Contact Info", style: .default, handler: { [weak self] _ in
			guard let strongSelf=self else {
				return
			}
			strongSelf.dismiss(animated: true) {
				NotificationCenter.default.post(name: .editContactInfo, object: nil)
			}
		}))
		addAction(UIAlertAction(title: "Change Card Color", style: .default, handler: { [weak self] _ in
			guard let strongSelf=self else {
				return
			}
			strongSelf.dismiss(animated: true) {
				NotificationCenter.default.post(name: .editColor, object: nil)
			}
		}))
		addAction(UIAlertAction(title: "Change Card Title", style: .default, handler: { [weak self] _ in
			guard let strongSelf=self else {
				return
			}
			strongSelf.dismiss(animated: true) {
				NotificationCenter.default.post(name: .editTitle, object: nil)
			}
		}))
		addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { [weak self] _ in
			guard let strongSelf=self else {
				return
			}
			strongSelf.dismiss(animated: true)
		}))
        // Do any additional setup after loading the view.
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
extension Notification.Name {
	static let editTitle=Notification.Name("edit-title")
	static let editColor=Notification.Name("edit-color")
	static let editContactInfo=Notification.Name("edit-contact-info")
}
/*
let storyboard = UIStoryboard(name: "Main", bundle: nil)
guard let saveContactCardViewController=storyboard.instantiateViewController(withIdentifier:
																				"SaveContactCardViewController")
		as? SaveContactCardViewController else {
	print("Failed to instantiate SaveContactCardViewController")
	return
}
saveContactCardViewController.forEditing=true
saveContactCardViewController.contact=strongSelf.contact
guard let contactCard=strongSelf.contactCard else {
	return
}
saveContactCardViewController.contactCard=contactCard
let navigationController=UINavigationController(rootViewController: saveContactCardViewController)
let contactCardTableViewController=strongSelf.presentingViewController
strongSelf.dismiss(animated: true) {
	print("Dismissed")
	contactCardTableViewController?.present(navigationController, animated: true)
}
*/
