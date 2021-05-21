//
//  ContactCardMOFunctions.swift
//  Contact Cards
//
//  Created by Matt Roberts on 5/21/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import Contacts
func setFields(contactCardMO: ContactCardMO, filename: String, cnContact: CNContact, color: String) {
	contactCardMO.filename=filename
	contactCardMO.vCardString=ContactDataConverter.cnContactToVCardString(cnContact: cnContact)
	//contactCardMO.uuidString=UUID().uuidString
	contactCardMO.color=color
}
func setContact(contactCardMO: ContactCardMO, cnContact: CNContact) {
	contactCardMO.vCardString=ContactDataConverter.cnContactToVCardString(cnContact: cnContact)
}
