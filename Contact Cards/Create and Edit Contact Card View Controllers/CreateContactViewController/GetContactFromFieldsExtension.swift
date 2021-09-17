//
//  GetContactFromFieldsExtension.swift
//  Contact Cards
//
//  Created by Matt Roberts on 7/14/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import UIKit
import Contacts
extension CreateContactViewController {
	public func getContactFromFields() -> CNMutableContact {
		let contact=CNMutableContact()
		if  !(firstNameTextField.text=="") {
			contact.givenName=firstNameTextField.text ?? ""
		}
		if  !(lastNameTextField.text=="") {
			contact.familyName=lastNameTextField.text ?? ""
		}
		if  !(prefixTextField.text=="") {
			contact.namePrefix=prefixTextField.text ?? ""
		}
		if  !(suffixTextField.text=="") {
			contact.nameSuffix=suffixTextField.text ?? ""
		}
		if  !(nicknameTextField.text=="") {
			contact.nickname=nicknameTextField.text ?? ""
		}
		if  !(companyTextField.text=="") {
			contact.organizationName=companyTextField.text ?? ""
		}
		if  !(jobTitleTextField.text=="") {
			contact.jobTitle=jobTitleTextField.text ?? ""
		}
		if  !(departmentTextField.text=="") {
			contact.departmentName=departmentTextField.text ?? ""
		}
		getPhoneNumbers(contact: contact)
		getEmails(contact: contact)
		getURLs(contact: contact)
		getAddresses(contact: contact)
		getSocialProfiles(contact: contact)
		return contact
	}
	private func getPhoneNumbers(contact: CNMutableContact) {
		if  !(mobilePhoneTextField.text=="") {
			let phone=CNPhoneNumber(stringValue: mobilePhoneTextField.text ?? "")
			contact.phoneNumbers.append(CNLabeledValue<CNPhoneNumber>(label: CNLabelPhoneNumberMobile, value: phone))
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
	}
	private func getEmails(contact: CNMutableContact) {
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
	}
	private func getURLs(contact: CNMutableContact) {
		if  !(urlHomeTextField.text=="") {
			var url=NSString(string:
								urlHomeTextField.text ?? "")
			url=validateURL(proposedURL: url as String) as NSString
			contact.urlAddresses.append(CNLabeledValue<NSString>(label: CNLabelHome, value: NSString(string: url)))
		}
		if  !(urlWork1TextField.text=="") {
			var url=NSString(string: urlWork1TextField.text ?? "")
			url=validateURL(proposedURL: url as String) as NSString
			contact.urlAddresses.append(CNLabeledValue<NSString>(label: CNLabelWork, value: url))
		}
		if  !(urlWork2TextField.text=="") {
			var url=NSString(string: urlWork2TextField.text ?? "")
			url=validateURL(proposedURL: url as String) as NSString
			contact.urlAddresses.append(CNLabeledValue<NSString>(label: CNLabelWork, value: url))
		}
		if  !(otherUrl1TextField.text=="") {
			var url=NSString(string: otherUrl1TextField.text ?? "")
			url=validateURL(proposedURL: url as String) as NSString
			contact.urlAddresses.append(CNLabeledValue<NSString>(label: CNLabelOther, value: url))
		}
		if  !(otherUrl2TextField.text=="") {
			var url=NSString(string: otherUrl2TextField.text ?? "")
			url=validateURL(proposedURL: url as String) as NSString
			contact.urlAddresses.append(CNLabeledValue<NSString>(label: CNLabelOther, value: url))
		}
	}
	private func getAddresses(contact: CNMutableContact) {
		if !(homeStreetTextField.text=="") || !(homeCityTextField.text=="") ||
			!(homeStateTextField.text=="") || !(homeZipTextField.text=="") {
			let address=CNMutablePostalAddress()
			address.street=homeStreetTextField.text ?? ""
			address.city=homeCityTextField.text ?? ""
			address.state=homeStateTextField.text ?? ""
			address.postalCode=homeZipTextField.text ?? ""
			contact.postalAddresses.append(CNLabeledValue<CNPostalAddress>(label: CNLabelHome, value: address))
		}
		if !(workStreetTextField.text=="") || !(workCityTextField.text=="") ||
			!(workStateTextField.text=="") || !(workZipTextField.text=="") {
			let address=CNMutablePostalAddress()
			address.street=workStreetTextField.text ?? ""
			address.city=workCityTextField.text ?? ""
			address.state=workStateTextField.text ?? ""
			address.postalCode=workZipTextField.text ?? ""
			contact.postalAddresses.append(CNLabeledValue<CNPostalAddress>(label: CNLabelWork, value: address))
		}
		if !(otherStreetTextField.text=="") || !(otherCityTextField.text=="") ||
			!(otherStateTextField.text=="") || !(otherZipTextField.text=="") {
			let address=CNMutablePostalAddress()
			address.street=otherStreetTextField.text ?? ""
			address.city=otherCityTextField.text ?? ""
			address.state=otherStateTextField.text ?? ""
			address.postalCode=otherZipTextField.text ?? ""
			contact.postalAddresses.append(CNLabeledValue<CNPostalAddress>(label: CNLabelOther, value: address))
		}
	}
	func getSocialProfiles(contact: CNMutableContact) {
		if !(twitterTextField.text=="") {
			contact.socialProfiles.append(CNLabeledValue<CNSocialProfile>(label: nil, value: CNSocialProfile(urlString: nil, username:
																												twitterTextField.text ?? "", userIdentifier: nil, service: CNSocialProfileServiceTwitter)))
		}
		if !(linkedInTextField.text=="") {
			var linkedInURL=linkedInTextField.text ?? ""
			if !linkedInURL.starts(with: "https://") && !linkedInURL.starts(with: "http://") {
				linkedInURL="https://\(linkedInURL)"
			}
			contact.socialProfiles.append(CNLabeledValue<CNSocialProfile>(label: nil, value: CNSocialProfile(urlString:
																												linkedInURL, username: linkedInURL, userIdentifier: nil, service: CNSocialProfileServiceLinkedIn)))
		}
		if !(facebookTextField.text=="") {
			var facebookURL=facebookTextField.text ?? ""
			if !facebookURL.starts(with: "https://") && !facebookURL.starts(with: "http://") {
				facebookURL="https://\(facebookURL)"
			}
			contact.socialProfiles.append(CNLabeledValue<CNSocialProfile>(label: nil, value: CNSocialProfile(urlString: facebookURL,
																											 username: facebookURL, userIdentifier: nil, service: CNSocialProfileServiceFacebook)))
		}
		if !(whatsAppTextField.text=="") {
			var whatsAppNumber=whatsAppTextField.text ?? ""
			whatsAppNumber = whatsAppNumber.filter("0123456789.".contains)

			let whatsAppURL="https://wa.me/\(whatsAppNumber)"
			contact.socialProfiles.append(CNLabeledValue<CNSocialProfile>(label: nil, value: CNSocialProfile(urlString: whatsAppURL,
																											 username: whatsAppNumber, userIdentifier: nil, service: "WhatsApp")))
		}
		if !(instagramTextField.text=="") {
			var instagramUsername=instagramTextField.text ?? ""
			instagramUsername = instagramUsername.replacingOccurrences(of: "@", with: "")

			let instagramURL="https://www.instagram.com/\(instagramUsername)"
			contact.socialProfiles.append(CNLabeledValue<CNSocialProfile>(label: nil, value: CNSocialProfile(urlString: instagramURL,
																											 username: instagramUsername, userIdentifier: nil, service: "Instagram")))
		}
		if !(snapchatTextField.text=="") {
			let snapchatUsername=snapchatTextField.text ?? ""

			let snapchatURL="https://www.snapchat.com/add/\(snapchatUsername)/"
			contact.socialProfiles.append(CNLabeledValue<CNSocialProfile>(label: nil, value: CNSocialProfile(urlString: snapchatURL,
																											 username: snapchatUsername, userIdentifier: nil, service: "Snapchat")))
		}
		if !(pinterestTextField.text=="") {
			let pinterestUsername=pinterestTextField.text ?? ""
			let pinterestURL="https://www.pinterest.com/\(pinterestUsername)"
			contact.socialProfiles.append(CNLabeledValue<CNSocialProfile>(label: nil, value: CNSocialProfile(urlString: pinterestURL,
																											 username: pinterestUsername, userIdentifier: nil, service: "Pinterest")))
		}
	}
}
