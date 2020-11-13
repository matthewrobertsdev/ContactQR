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
	@IBOutlet weak var homeStreetTextField: UITextField!
	@IBOutlet weak var homeCityTextField: UITextField!
	@IBOutlet weak var homeStateTextField: UITextField!
	@IBOutlet weak var homeZipTextField: UITextField!
	@IBOutlet weak var workStreetTextField: UITextField!
	@IBOutlet weak var workStateTextField: UITextField!
	@IBOutlet weak var workCityTextField: UITextField!
	@IBOutlet weak var workZipTextField: UITextField!
	@IBOutlet weak var otherStreetTextField: UITextField!
	@IBOutlet weak var otherCityTextField: UITextField!
	@IBOutlet weak var otherStateTextField: UITextField!
	@IBOutlet weak var otherZipTextField: UITextField!
	var contact=CNContact()
	@IBAction func cancel(_ sender: Any) {
		self.dismiss(animated: true)
	}
	@IBAction func createContact(_ sender: Any) {
		let contact=CNMutableContact()
		if  !(firstNameTextField.text=="") {
			contact.givenName=firstNameTextField.text ?? ""
		}
		if  !(lastNameTextField.text=="") {
			contact.familyName=lastNameTextField.text ?? ""
		}
		if  !(mobilePhoneTextField.text=="") {
		let phone=CNPhoneNumber(stringValue: mobilePhoneTextField.text ?? "")
			contact.phoneNumbers.append(CNLabeledValue<CNPhoneNumber>(label: CNLabelPhoneNumberMobile, value:phone))
		}
		if  !(workPhone1TextField.text=="") {
		let phone=CNPhoneNumber(stringValue: workPhone1TextField.text ?? "")
			contact.phoneNumbers.append(CNLabeledValue<CNPhoneNumber>(label: CNLabelWork, value: phone))
		}
		if  !(workPhone2TextField.text=="") {
		let phone=CNPhoneNumber(stringValue: workPhone2TextField.text ?? "")
			contact.phoneNumbers.append(CNLabeledValue<CNPhoneNumber>(label: CNLabelWork, value: phone))
		}
		if  !(homePhoneTextField.text=="") {
			let phone=CNPhoneNumber(stringValue: homePhoneTextField.text ?? "")
			contact.phoneNumbers.append(CNLabeledValue<CNPhoneNumber>(label: CNLabelHome, value: phone))
		}
		if  !(otherPhoneTextField.text=="") {
			let phone=CNPhoneNumber(stringValue: otherPhoneTextField.text ?? "")
			contact.phoneNumbers.append(CNLabeledValue<CNPhoneNumber>(label: CNLabelOther, value: phone))
		}
		if  !(homeEmailTextField.text=="") {
		let email=NSString(string: homeEmailTextField.text ?? "")
			contact.emailAddresses.append(CNLabeledValue<NSString>(label: CNLabelHome, value: NSString(string: email)))
		}
		if  !(workEmail1TextField.text=="") {
		let email=NSString(string: workEmail1TextField.text ?? "")
			contact.emailAddresses.append(CNLabeledValue<NSString>(label: CNLabelWork, value: email))
		}
		if  !(workEmail2TextField.text=="") {
		let email=NSString(string: workEmail2TextField.text ?? "")
			contact.emailAddresses.append(CNLabeledValue<NSString>(label: CNLabelWork, value: email))
		}
		if  !(otherEmailTextField.text=="") {
		let email=NSString(string: otherEmailTextField.text ?? "")
			contact.emailAddresses.append(CNLabeledValue<NSString>(label: CNLabelOther, value: NSString(string: email)))
		}
		if  !(urlHomeTextField.text=="") {
		let url=NSString(string: urlHomeTextField.text ?? "")
			contact.urlAddresses.append(CNLabeledValue<NSString>(label: CNLabelHome, value: NSString(string: url)))
		}
		if  !(urlWork1TextField.text=="") {
		let url=NSString(string: urlWork1TextField.text ?? "")
			contact.urlAddresses.append(CNLabeledValue<NSString>(label: CNLabelWork, value: url))
		}
		if  !(urlWork2TextField.text=="") {
		let url=NSString(string: urlWork2TextField.text ?? "")
			contact.urlAddresses.append(CNLabeledValue<NSString>(label: CNLabelWork, value: url))
		}
		if  !(otherUrl1TextField.text=="") {
		let url=NSString(string: otherUrl1TextField.text ?? "")
			contact.urlAddresses.append(CNLabeledValue<NSString>(label: CNLabelOther, value: url))
		}
		if  !(otherUrl2TextField.text=="") {
		let url=NSString(string: otherUrl2TextField.text ?? "")
			contact.urlAddresses.append(CNLabeledValue<NSString>(label: CNLabelOther, value: url))
		}
		if !(homeStreetTextField.text=="") || !(homeCityTextField.text=="") || !(homeStateTextField.text=="") || !(homeZipTextField.text=="") {
		let address=CNMutablePostalAddress()
			address.street=homeStreetTextField.text ?? ""
			address.city=homeCityTextField.text ?? ""
			address.state=homeStateTextField.text ?? ""
			address.postalCode=homeZipTextField.text ?? ""
			contact.postalAddresses.append(CNLabeledValue<CNPostalAddress>(label: CNLabelHome, value: address))
			}
		if !(workStreetTextField.text=="") || !(workCityTextField.text=="") || !(workStateTextField.text=="") || !(workZipTextField.text=="") {
		let address=CNMutablePostalAddress()
			address.street=workStreetTextField.text ?? ""
			address.city=workCityTextField.text ?? ""
			address.state=workStateTextField.text ?? ""
			address.postalCode=workZipTextField.text ?? ""
			contact.postalAddresses.append(CNLabeledValue<CNPostalAddress>(label: CNLabelWork, value: address))
			}
		if !(otherStreetTextField.text=="") || !(otherCityTextField.text=="") || !(otherStateTextField.text=="") || !(otherZipTextField.text=="") {
		let address=CNMutablePostalAddress()
			address.street=otherStreetTextField.text ?? ""
			address.city=otherCityTextField.text ?? ""
			address.state=otherStateTextField.text ?? ""
			address.postalCode=otherZipTextField.text ?? ""
			contact.postalAddresses.append(CNLabeledValue<CNPostalAddress>(label: CNLabelOther, value: address))
			}
		ActiveContact.shared.contact=contact
		NotificationCenter.default.post(name: .contactCreated, object: self, userInfo: ["animated": true])
	}
	func fillWithContact(contact: CNContact) {
		firstNameTextField.text=contact.givenName
		lastNameTextField.text=contact.familyName
		let phoneNumbers=contact.phoneNumbers
		mobilePhoneTextField.text=phoneNumbers.first(where: {  (labeledNumber) in
			return labeledNumber.label==CNLabelPhoneNumberMobile
		})?.value.stringValue
		let workPhoneNumbers=phoneNumbers.filter({ (labeledNumber) in
			return labeledNumber.label==CNLabelWork
		})
		workPhone1TextField.text=workPhoneNumbers.first?.value.stringValue
		if (workPhoneNumbers.count>1) {
			workPhone2TextField.text=workPhoneNumbers[1].value.stringValue
		}
		homePhoneTextField.text=phoneNumbers.first(where: {  (labeledNumber) in
			return labeledNumber.label==CNLabelHome
		})?.value.stringValue
		otherPhoneTextField.text=phoneNumbers.first(where: {  (labeledNumber) in
			return labeledNumber.label==CNLabelOther
		})?.value.stringValue
		let emails=contact.emailAddresses
		homeEmailTextField.text=emails.first(where: {  (labeledNumber) in
			return labeledNumber.label==CNLabelHome
		})?.value.substring(from: 0)
		otherEmailTextField.text=emails.first(where: {  (labeledNumber) in
			return labeledNumber.label==CNLabelOther
		})?.value.substring(from: 0)
		let workEmails=phoneNumbers.filter({ (labeledEmail) in
			return labeledEmail.label==CNLabelWork
		})
		workEmail1TextField.text=workEmails.first?.value.stringValue
		if (workPhoneNumbers.count>1) {
			workEmail2TextField.text=workEmails[1].value.stringValue
		}
		/*
		@IBOutlet weak var urlHomeTextField: UITextField!
		@IBOutlet weak var urlWork1TextField: UITextField!
		@IBOutlet weak var urlWork2TextField: UITextField!
		@IBOutlet weak var otherUrl1TextField: UITextField!
		@IBOutlet weak var otherUrl2TextField: UITextField!
		@IBOutlet weak var homeStreetTextField: UITextField!
		@IBOutlet weak var homeCityTextField: UITextField!
		@IBOutlet weak var homeStateTextField: UITextField!
		@IBOutlet weak var homeZipTextField: UITextField!
		@IBOutlet weak var workStreetTextField: UITextField!
		@IBOutlet weak var workStateTextField: UITextField!
		@IBOutlet weak var workCityTextField: UITextField!
		@IBOutlet weak var workZipTextField: UITextField!
		@IBOutlet weak var otherStreetTextField: UITextField!
		@IBOutlet weak var otherCityTextField: UITextField!
		@IBOutlet weak var otherStateTextField: UITextField!
		@IBOutlet weak var otherZipTextField: UITextField!
		*/
	}
	override func viewDidLoad() {
        super.viewDidLoad()
		fillWithContact(contact: contact)
		//NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification,
		//object: Any?.self, queue: OperationQueue.main) { (notification) in
			let notificationCenter = NotificationCenter.default
			notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
			notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
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
