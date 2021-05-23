//
//  ContactCardMOFunctions.swift
//  Contact Cards
//
//  Created by Matt Roberts on 5/21/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import Contacts
import UIKit
func setFields(contactCardMO: ContactCardMO, filename: String, cnContact: CNContact, color: String) {
	contactCardMO.filename=filename
	contactCardMO.vCardString=ContactDataConverter.cnContactToVCardString(cnContact: cnContact)
	contactCardMO.color=color
	setQRCode(contactCardMO: contactCardMO)
}
func setContact(contactCardMO: ContactCardMO, cnContact: CNContact) {
	contactCardMO.vCardString=ContactDataConverter.cnContactToVCardString(cnContact: cnContact)
	setQRCode(contactCardMO: contactCardMO)
}
func setQRCode(contactCardMO: ContactCardMO) {
	let model=DisplayQRModel()
	model.setUp(contactCard: contactCardMO)
	if let qrCode=model.makeQRCode() {
		contactCardMO.qrCodeImage=getTintedForeground(image: qrCode, color: UIColor.label).withRenderingMode(.alwaysTemplate).pngData()
	}
}
