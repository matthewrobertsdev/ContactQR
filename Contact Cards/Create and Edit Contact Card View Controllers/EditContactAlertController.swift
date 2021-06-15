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
	var contactCard: ContactCardMO?
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
		addAction(UIAlertAction(title: "Edit Card Color", style: .default, handler: { [weak self] _ in
			guard let strongSelf=self else {
				return
			}
			strongSelf.dismiss(animated: true) {
				NotificationCenter.default.post(name: .editColor, object: nil)
			}
		}))
		addAction(UIAlertAction(title: "Edit Card Title", style: .default, handler: { [weak self] _ in
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
}
extension Notification.Name {
	static let editTitle=Notification.Name("edit-title")
	static let editColor=Notification.Name("edit-color")
	static let editContactInfo=Notification.Name("edit-contact-info")
}
