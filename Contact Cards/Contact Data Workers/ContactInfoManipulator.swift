//
//  ContactImnfoManipulator.swift
//  Contact Cards
//
//  Created by Matt Roberts on 12/26/18.
//  Copyright © 2018 Matt Roberts. All rights reserved.
//

import Foundation
import Contacts
import UIKit
/*
 Gets fields from CNContact and returns them as an array of String pairs
 with the name of the field and the value for each pair
 */
class ContactInfoManipulator {
    static func createPreviewString(cnContact: CNContact) -> String {
        var contactPreviewString=""
        if !(cnContact.namePrefix=="") {
            contactPreviewString.append(cnContact.namePrefix+" ")
        }
        if !(cnContact.givenName=="") {
            contactPreviewString.append(cnContact.givenName+" ")
        }
        if !(cnContact.familyName=="") {
            contactPreviewString.append(cnContact.familyName+" ")
        }
        if !(cnContact.nameSuffix=="") {
            contactPreviewString.append(cnContact.nameSuffix+" ")
        }
        if !(cnContact.nickname=="") {
            contactPreviewString.append(cnContact.nickname+" ")
        }
        for phoneNumber in (cnContact.phoneNumbers) {
            contactPreviewString.append(phoneNumber.value.stringValue+" ")
        }
        for emailAddress in (cnContact.emailAddresses) {
            contactPreviewString.append(emailAddress.value as String+" ")
        }
        for urlAddress in (cnContact.urlAddresses) {
            contactPreviewString.append( urlAddress.value as String+" ")
        }
        contactPreviewString.append(createPostalPreviewString(cnContact: cnContact))
        return contactPreviewString
    }
    private static func createPostalPreviewString(cnContact: CNContact) -> String {
        var contactPreviewString=""
        for postalAddress in (cnContact.postalAddresses) {
            if !(postalAddress.value.street=="") {
                contactPreviewString.append(postalAddress.value.street as String+" ")
            }
            if !(postalAddress.value.city=="") {
                contactPreviewString.append( postalAddress.value.city as String+" ")
            }
            if !(postalAddress.value.state=="") {
                contactPreviewString.append( postalAddress.value.state as String+" ")
            }
            if !(postalAddress.value.postalCode=="") {
                contactPreviewString.append( postalAddress.value.postalCode as String+" ")
            }
            if !(postalAddress.value.country=="") {
                contactPreviewString.append( postalAddress.value.country as String+" ")
            }
        }
        return contactPreviewString
    }
    //get an array of pairs of Strings from a CNContact
    static func makeContactInfoArray(cnContact: CNContact?) -> [(String, String)] {
        var contactInfoArray: [(String, String)]=[]
        if cnContact==nil {
            //leave it empty
        } else {
            if !(cnContact?.namePrefix=="") {
                contactInfoArray.append(("Prefix", (cnContact?.namePrefix)!))
            }
            if !(cnContact?.givenName=="") {
                contactInfoArray.append(("First", (cnContact?.givenName)!))
            }
            if !(cnContact?.familyName=="") {
                contactInfoArray.append(("Last", (cnContact?.familyName)!))
            }
            if !(cnContact?.nameSuffix=="") {
                contactInfoArray.append(("Suffix", (cnContact?.nameSuffix)!))
            }
            if !(cnContact?.nickname=="") {
                contactInfoArray.append(("Nickname", (cnContact?.nickname)!))
            }
            for phoneNumber in (cnContact?.phoneNumbers)! {
                let phoneNumberLabel=ContactInfoManipulator.makeContactLabel(label: phoneNumber.label!)
                contactInfoArray.append((phoneNumberLabel, phoneNumber.value.stringValue))
            }
            for emailAddress in (cnContact?.emailAddresses)! where emailAddress.label != nil {
					let emailAddressLabel=ContactInfoManipulator.makeContactLabel(label: emailAddress.label!)
					contactInfoArray.append((emailAddressLabel, emailAddress.value as String))
            }
            for urlAddress in (cnContact?.urlAddresses)! where urlAddress.label != nil {
					let urlAddresslabel=ContactInfoManipulator.makeContactLabel(label: urlAddress.label!)
					contactInfoArray.append((urlAddresslabel, urlAddress.value as String))
            }
			for address in (cnContact?.postalAddresses)! {
					let addressLabel=ContactInfoManipulator.makeContactLabel(label: address.label ?? "")
					contactInfoArray.append((addressLabel, address.value.street as String))
					contactInfoArray.append((addressLabel, address.value.city as String))
					contactInfoArray.append((addressLabel, address.value.state as String))
					contactInfoArray.append((addressLabel, address.value.postalCode as String))
            }
        }
        return contactInfoArray
    }
    private static func createPostalPreviewString(cnContact: CNContact?) -> [(String, String)] {
        var contactInfoArray: [(String, String)]=[]
        for postalAddress in (cnContact?.postalAddresses)! {
            let postalAddresslabel=ContactInfoManipulator.makeContactLabel(label: postalAddress.label!)
            if !(postalAddress.value.street=="") {
                contactInfoArray.append((postalAddresslabel, postalAddress.value.street))
            }
            if !(postalAddress.value.city=="") {
                contactInfoArray.append((postalAddresslabel, postalAddress.value.city))
            }
            if !(postalAddress.value.state=="") {
                contactInfoArray.append((postalAddresslabel, postalAddress.value.state))
            }
            if !(postalAddress.value.postalCode=="") {
                contactInfoArray.append((postalAddresslabel, postalAddress.value.postalCode))
            }
            if !(postalAddress.value.country=="") {
                contactInfoArray.append((postalAddresslabel, postalAddress.value.country))
            }
        }
        return contactInfoArray
    }
    static func makeContactLabel(label: String) -> String {
        var displayLabel=label
        if displayLabel.count<4 {
            return ""
        }
        let removeStartRange=displayLabel.startIndex..<label.index(displayLabel.startIndex, offsetBy: 4)
        displayLabel.removeSubrange(removeStartRange)
        if displayLabel.count<4 {
            return ""
        }
        let removeEndRange=displayLabel.index(displayLabel.endIndex, offsetBy: -4)..<displayLabel.endIndex
        displayLabel.removeSubrange(removeEndRange)
        return String(displayLabel)
    }
	static func makeContactDisplayArray(contactInfo: [(String, String)]) -> [String] {
		var infoStrings=[String]()
		for info in contactInfo {
			if info.0 != "" {
				infoStrings.append(info.0+":")
			}
			infoStrings.append(info.1)
		}
		return infoStrings
	}
	static func makeContactDisplayString(cnContact: CNContact?, fontSize: CGFloat) -> NSAttributedString {
		let displayString=NSMutableAttributedString()
		var basicString=""
		guard let cnContact=cnContact else {
			return NSAttributedString()
		}
		if !(cnContact.namePrefix=="") {
			basicString+="Prefix:  \(cnContact.namePrefix)\n\n"
		}
		if !(cnContact.givenName=="") {
			basicString+="First Name:  \(cnContact.givenName)\n\n"
		}
		if !(cnContact.familyName=="") {
			basicString+="Last Name:  \(cnContact.familyName)\n\n"
			}
		if !(cnContact.nameSuffix=="") {
			basicString+="Suffix:  \(cnContact.nameSuffix)\n\n"
		}
			if !(cnContact.nickname=="") {
				basicString+="Nickname:  \(cnContact.nickname)\n\n"
			}
		if !(cnContact.organizationName=="") {
			basicString+="Company:  \(cnContact.organizationName)\n\n"
		}
		if !(cnContact.jobTitle=="") {
			basicString+="Job Title:  \(cnContact.jobTitle)\n\n"
		}
		if !(cnContact.departmentName=="") {
			basicString+="Department:  \(cnContact.departmentName)\n\n"
		}
			displayString.append(NSAttributedString(string: basicString))
			basicString=""
			for phoneNumber in cnContact.phoneNumbers {
				var phoneLabelString=""
				if let phoneNumberLabel=phoneNumber.label {
					phoneLabelString =
					makeContactLabel(label: phoneNumberLabel)
				}
				let linkString=phoneNumber.value.stringValue
				addLink(stringToAddTo: displayString, label: phoneLabelString+" Phone", linkModifer: "tel://", basicLink: linkString)
			}
			for emailAddress in cnContact.emailAddresses {
				var emailLabelString=""
				if let emailLabel=emailAddress.label { emailLabelString =
					makeContactLabel(label: emailLabel)
				}
				let linkString=emailAddress.value as String
				addLink(stringToAddTo: displayString, label: emailLabelString+" Email", linkModifer: "mailto:", basicLink: linkString)
			}
		addSocialProfiles(cnContact: cnContact, displayString: displayString)
			for urlAddress in (cnContact.urlAddresses) {
				var urlAddressLabelString=""
				if let urlAddressLabel=urlAddress.label { urlAddressLabelString =
					makeContactLabel(label: urlAddressLabel)
				}
				let linkString=urlAddress.value as String
				addLink(stringToAddTo: displayString, label: urlAddressLabelString+" URL", linkModifer: "", basicLink: linkString)
			}
			basicString=""
			for address in cnContact.postalAddresses {
				var addressLabelString=""
				if let addressLabel=address.label { addressLabelString =
					makeContactLabel(label: addressLabel)
				}
				displayString.append(NSMutableAttributedString(string: "\(addressLabelString) Address: "))
				let addressDisplayString=NSMutableAttributedString(string:
																"\(address.value.street as String)\n \(address.value.city as String) \(address.value.state) \(address.value.postalCode)")
				let addressString=NSMutableAttributedString(string:
																"\(address.value.street as String) \(address.value.city as String) \(address.value.state) \(address.value.postalCode)")
				let searchAddressString=addressString.mutableString.replacingOccurrences(of: " ", with: "+")
				addressDisplayString.addAttribute(.link, value: "http://maps.apple.com/?q=\(searchAddressString)", range: NSRange(location: 0, length: addressDisplayString.length))
				displayString.append(addressDisplayString)
				displayString.append(NSAttributedString(string: "\n\n"))
			}
		addBasicFormatting(displayString: displayString, fontSize: fontSize)
		return displayString
	}
	static func addSocialProfiles(cnContact: CNContact, displayString: NSMutableAttributedString) {
		if let twitterUsername=cnContact.socialProfiles.first(where: { (socialProfile) -> Bool in
			return socialProfile.value.service.lowercased()==CNSocialProfileServiceTwitter.lowercased()
		})?.value.username {
			addLink(stringToAddTo: displayString, label: "Twitter Username", linkModifer: "https://twitter.com/", basicLink: twitterUsername)
		}
		if let linkedInURL=cnContact.socialProfiles.first(where: { (socialProfile) -> Bool in
			return socialProfile.value.service.lowercased()==CNSocialProfileServiceLinkedIn.lowercased()
		})?.value.urlString {
			if linkedInURL != "" {
				addLink(stringToAddTo: displayString, label: "LinkedIn URL", linkModifer: "", basicLink: linkedInURL)
			}
		}
		if let facebookURL=cnContact.socialProfiles.first(where: { (socialProfile) -> Bool in
			return socialProfile.value.service.lowercased()==CNSocialProfileServiceFacebook.lowercased()
		})?.value.urlString {
			if facebookURL != "" {
				addLink(stringToAddTo: displayString, label: "Facebook URL", linkModifer: "", basicLink: facebookURL)
			}
		}
		if let whatsAppNumber=cnContact.socialProfiles.first(where: { (socialProfile) -> Bool in
			return socialProfile.value.service.lowercased()=="WhatsApp".lowercased()
		})?.value.username {
			if whatsAppNumber != "" {
				addLink(stringToAddTo: displayString, label: "WhatsApp Number", linkModifer: "https://wa.me/", basicLink: whatsAppNumber)
			}
		}
		if let instagramUsername=cnContact.socialProfiles.first(where: { (socialProfile) -> Bool in
			return socialProfile.value.service.lowercased()=="Instagram".lowercased()
		})?.value.username {
			if instagramUsername != "" {
				addLink(stringToAddTo: displayString, label: "Instagram Username", linkModifer: "https://www.instagram.com/", basicLink: instagramUsername)
			}
		}
		if let snapchatUsername=cnContact.socialProfiles.first(where: { (socialProfile) -> Bool in
			return socialProfile.value.service.lowercased()=="Snapchat".lowercased()
		})?.value.username {
			if snapchatUsername != "" {
				addLink(stringToAddTo: displayString, label: "Snapchat Username", linkModifer: "https://www.snapchat.com/add/", basicLink: snapchatUsername)
			}
		}
		if let pinterestUsername=cnContact.socialProfiles.first(where: { (socialProfile) -> Bool in
			return socialProfile.value.service.lowercased()=="Pinterest".lowercased()
		})?.value.username {
			if pinterestUsername != "" {
				addLink(stringToAddTo: displayString, label: "Pinterest Username", linkModifer: "https://www.pinterest.com/", basicLink: pinterestUsername)
			}
		}
	}
	static func addLink(stringToAddTo: NSMutableAttributedString, label: String, linkModifer: String, basicLink: String) {
		stringToAddTo.append(NSAttributedString(string: "\(label): "))
		let urlString=NSMutableAttributedString(string: basicLink)
		urlString.addAttribute(.link, value: linkModifer+basicLink, range: NSRange(location: 0, length: urlString.length))
		stringToAddTo.append(urlString)
		stringToAddTo.append(NSAttributedString(string: "\n\n"))
	}
	static func getBadVCardAttributedString(fontSize: CGFloat) -> NSAttributedString {
		let badVCardWarning=NSMutableAttributedString(string: "One or more of the data was invalid.  Probably something you "
											+ "inputted is too long for that kind of contact info.  "
		+ "Please edit the contact info until it is sharable as a file.")
		addBasicFormatting(displayString: badVCardWarning, fontSize: fontSize)
		return badVCardWarning
	}
	static func addBasicFormatting(displayString: NSMutableAttributedString, fontSize: CGFloat) {
		let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
			paragraphStyle.alignment = NSTextAlignment.center
		var color=UIColor.white
		#if os(watchOS)
		#else
		color=UIColor.label
		#endif
		let fontAttributes = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.light),
							   NSAttributedString.Key.paragraphStyle: paragraphStyle, .foregroundColor: color]

		displayString.addAttributes(fontAttributes, range: NSRange(location: 0, length: displayString.length))
	}
}
