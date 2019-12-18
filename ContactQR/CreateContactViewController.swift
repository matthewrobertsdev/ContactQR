//
//  CreateContactViewController.swift
//  ContactQR
//
//  Created by Matt Roberts on 12/17/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//

import UIKit
import Contacts

class CreateContactViewController: UIViewController {
	@IBOutlet weak var firstNameTextField: UITextField!
	@IBOutlet weak var lastNameTextField: UITextField!
	@IBOutlet weak var companyTextField: UITextField!
	@IBOutlet weak var mobilePhoneTextField: UITextField!
	@IBOutlet weak var workPhone1TextField: UITextField!
	@IBOutlet weak var workPhone2TextField: UITextField!
	@IBOutlet weak var homePhoneTextField: UITextField!
	@IBOutlet weak var otherPhoneTextField: UITextField!
	@IBOutlet weak var homeEmailTextField: UITextField!
	@IBOutlet weak var workEmail1TextField: UITextField!
	@IBOutlet weak var workEmail2TextField: UITextField!
	@IBOutlet weak var otherEmailTextField: UITextField!
	@IBOutlet weak var urlHomeTextField: UITextField!
	@IBOutlet weak var urlWork1TextField: UITextField!
	@IBOutlet weak var urlWork2TextField: UITextField!
	@IBOutlet weak var otherUrl1TextField: UITextField!
	@IBOutlet weak var otherUrl2TextField: UITextField!
	@IBOutlet weak var homeAddress1TextField: UITextField!
	@IBOutlet weak var homeAddress2TextField: UITextField!
	@IBOutlet weak var workAddress1TextField: UITextField!
	@IBOutlet weak var workAddress2TextField: UITextField!
	@IBOutlet weak var otherAddress1TextField: UITextField!
	@IBOutlet weak var otherAddress2TextField: UITextField!
	@IBAction func cancel(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	@IBAction func createQRCode(_ sender: Any) {
		let contact=CNMutableContact()
		if  !(firstNameTextField.text=="") {
			contact.givenName=firstNameTextField.text ?? ""
		}
		ActiveContact.shared.contact=contact
		NotificationCenter.default.post(name: .contactCreated, object: self)
	}
	override func viewDidLoad() {
        super.viewDidLoad()
		//NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification,
		//object: Any?.self, queue: OperationQueue.main) { (notification) in
			let notificationCenter = NotificationCenter.default
			notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
			notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
			print("abcd")
			//self.stackViewHeight.constant=900
			//self.fieldsStackView.updateConstraints()
		//}
        // Do any additional setup after loading the view.
    }
	@IBOutlet weak var fieldsScrollView: UIScrollView!
	/*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
	@objc func adjustForKeyboard(notification: Notification) {
		guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
		let keyboardScreenEndFrame = keyboardValue.cgRectValue
		let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

		if notification.name == UIResponder.keyboardWillHideNotification {
			fieldsScrollView.contentInset = .zero
		} else {
			fieldsScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
		}
		fieldsScrollView.scrollIndicatorInsets = fieldsScrollView.contentInset
	}
}
