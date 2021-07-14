//
//  FillFieldsFromContactExtension.swift
//  Contact Cards
//
//  Created by Matt Roberts on 7/14/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import UIKit
import Contacts
extension CreateContactViewController {
	func clearFields() {
		firstNameTextField.text=""
		lastNameTextField.text=""
		prefixTextField.text=""
		suffixTextField.text=""
		nicknameTextField.text=""
		companyTextField.text=""
		jobTitleTextField.text=""
		departmentTextField.text=""
		mobilePhoneTextField.text=""
		workPhone1TextField.text=""
		workPhone2TextField.text=""
		homePhoneTextField.text=""
		otherPhoneTextField.text=""
		homeEmailTextField.text=""
		workEmail1TextField.text=""
		workEmail2TextField.text=""
		otherEmailTextField.text=""
		facebookTextField.text=""
		linkedInTextField.text=""
		twitterTextField.text=""
		urlHomeTextField.text=""
		urlWork1TextField.text=""
		urlWork2TextField.text=""
		otherUrl1TextField.text=""
		otherUrl2TextField.text=""
		homeStreetTextField.text=""
		homeCityTextField.text=""
		homeStateTextField.text=""
		homeZipTextField.text=""
		workStreetTextField.text=""
		workStateTextField.text=""
		workCityTextField.text=""
		workZipTextField.text=""
		otherStreetTextField.text=""
		otherCityTextField.text=""
		otherStateTextField.text=""
		otherZipTextField.text=""
	}
	public func fillWithContact(contact: CNContact) {
		firstNameTextField.text=contact.givenName
		lastNameTextField.text=contact.familyName
		prefixTextField.text=contact.namePrefix
		suffixTextField.text=contact.nameSuffix
		nicknameTextField.text=contact.nickname
		companyTextField.text=contact.organizationName
		jobTitleTextField.text=contact.jobTitle
		departmentTextField.text=contact.departmentName
		fillPhoneNumbers(contact: contact)
		fillEmails(contact: contact)
		fillSocialProfiles(contact: contact)
		fillUrls(contact: contact)
		fillPostalAddresses(contact: contact)
	}
	private func fillPhoneNumbers(contact: CNContact) {
		let phoneNumbers=contact.phoneNumbers
		mobilePhoneTextField.text=phoneNumbers.first(where: {  (labeledNumber) in
			return labeledNumber.label==CNLabelPhoneNumberMobile || labeledNumber.label==CNLabelPhoneNumberiPhone
		})?.value.stringValue
		let workPhoneNumbers=phoneNumbers.filter({ (labeledNumber) in
			return labeledNumber.label==CNLabelWork
		})
		workPhone1TextField.text=workPhoneNumbers.first?.value.stringValue
		if workPhoneNumbers.count>1 {
			workPhone2TextField.text=workPhoneNumbers[1].value.stringValue
		}
		homePhoneTextField.text=phoneNumbers.first(where: {  (labeledNumber) in
			return labeledNumber.label==CNLabelHome
		})?.value.stringValue
		otherPhoneTextField.text=phoneNumbers.first(where: {  (labeledNumber) in
			return labeledNumber.label==CNLabelOther
		})?.value.stringValue
	}
	private func fillEmails(contact: CNContact) {
		let emails=contact.emailAddresses
		homeEmailTextField.text=emails.first(where: {  (labeledNumber) in
			return labeledNumber.label==CNLabelHome
		})?.value.substring(from: 0)
		otherEmailTextField.text=emails.first(where: {  (labeledNumber) in
			return labeledNumber.label==CNLabelOther
		})?.value.substring(from: 0)
		let workEmails=emails.filter({ (labeledEmail) in
			return labeledEmail.label==CNLabelWork
		})
		workEmail1TextField.text=workEmails.first?.value.substring(from: 0)
		if emails.count>1 {
			workEmail2TextField.text=workEmails[1].value.substring(from: 0)
		}
	}
	private func fillSocialProfiles(contact: CNContact) {
		let socialProfiles=contact.socialProfiles
		twitterTextField.text=socialProfiles.first(where: {  (socialProfile) in
			return socialProfile.value.service.lowercased()==CNSocialProfileServiceTwitter.lowercased()
		})?.value.username
		linkedInTextField.text=socialProfiles.first(where: {  (socialProfile) in
			return socialProfile.value.service.lowercased()==CNSocialProfileServiceLinkedIn.lowercased()
		})?.value.urlString
		facebookTextField.text=socialProfiles.first(where: {  (socialProfile) in
			return socialProfile.value.service.lowercased()==CNSocialProfileServiceFacebook.lowercased()
		})?.value.urlString
	}
	private func fillUrls(contact: CNContact) {
		let urls=contact.urlAddresses
		urlHomeTextField.text = urls.first(where: { (labeledUrl) in
			return labeledUrl.label==CNLabelHome
		})?.value.substring(from: 0)
		let workUrls=urls.filter({ (labeledNumber) in
			return labeledNumber.label==CNLabelWork
		})
		urlWork1TextField.text=workUrls.first?.value.substring(from: 0)
		if workUrls.count>1 {
			urlWork2TextField.text=workUrls[1].value.substring(from: 0)
		}
		let otherUrls=urls.filter({ (labeledNumber) in
			return labeledNumber.label==CNLabelOther
		})
		otherUrl1TextField.text=otherUrls.first?.value.substring(from: 0)
		if otherUrls.count>1 {
			otherUrl2TextField.text=otherUrls[1].value.substring(from: 0)
		}
	}
	private func fillPostalAddresses(contact: CNContact) {
		let addresses=contact.postalAddresses
		let firstHomeAddress=addresses.first { (address) -> Bool in
			address.label==CNLabelHome
		}?.value
		if let homeAddress=firstHomeAddress {
			homeStreetTextField.text=homeAddress.street
			homeCityTextField.text=homeAddress.city
			homeStateTextField.text=homeAddress.state
			homeZipTextField.text=homeAddress.postalCode
		}
		let firstWorkAddress=addresses.first { (address) -> Bool in
			address.label==CNLabelWork
		}?.value
		if let workAddress=firstWorkAddress {
			workStreetTextField.text=workAddress.street
			workCityTextField.text=workAddress.city
			workStateTextField.text=workAddress.state
			workZipTextField.text=workAddress.postalCode
		}
		let firstOtherAddress=addresses.first { (address) -> Bool in
			address.label==CNLabelOther
		}?.value
		if let otherAddress=firstOtherAddress {
			otherStreetTextField.text=otherAddress.street
			otherCityTextField.text=otherAddress.city
			otherStateTextField.text=otherAddress.state
			otherZipTextField.text=otherAddress.postalCode
		}
	}
}
