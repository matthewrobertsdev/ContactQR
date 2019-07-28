//
//  ContactImnfoManipulator.swift
//  CardQR
//
//  Created by Matt Roberts on 12/26/18.
//  Copyright © 2018 Matt Roberts. All rights reserved.
//

import Foundation
import Contacts
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
            for emailAddress in (cnContact?.emailAddresses)! {
                let emailAddressLabel=ContactInfoManipulator.makeContactLabel(label: emailAddress.label!)
                contactInfoArray.append((emailAddressLabel, emailAddress.value as String))
            }
            for urlAddress in (cnContact?.urlAddresses)! {
                let urlAddresslabel=ContactInfoManipulator.makeContactLabel(label: urlAddress.label!)
                contactInfoArray.append((urlAddresslabel, urlAddress.value as String))
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
}
