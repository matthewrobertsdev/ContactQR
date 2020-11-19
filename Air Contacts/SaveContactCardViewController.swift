//
//  SaveContactCardViewController.swift
//  Air Contacts
//
//  Created by Matt Roberts on 11/15/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import UIKit
import Contacts
class SaveContactCardViewController: UIViewController, UITextFieldDelegate {
	@IBOutlet weak var saveButton: UIBarButtonItem!
	@IBOutlet weak var titleTextField: UITextField!
	var contact=CNContact()
    override func viewDidLoad() {
        super.viewDidLoad()
		saveButton.isEnabled=false
		titleTextField.addTarget(self, action: #selector(enableOrDisableSaveButton), for: .editingChanged)
    }
	@IBAction func save(_ sender: Any) {
		let contactCard=ContactCard(filename: titleTextField.text ?? "No Title Given", cnContact: contact)
		ContactCardStore.sharedInstance.contacts.append(contactCard)
		dismiss(animated: true) {
			NotificationCenter.default.post(name: .contactCreated, object: self, userInfo: nil)
		}
	}
	@IBAction func cancel(_ sender: Any) {
		dismiss(animated: true)
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
}
