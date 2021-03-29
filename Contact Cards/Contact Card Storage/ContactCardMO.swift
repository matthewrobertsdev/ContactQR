//
//  ContactCardMO.swift
//  Contact Cards
//
//  Created by Matt Roberts on 3/22/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//

import Foundation
import CoreData

import Contacts

class ContactCardMO: NSManagedObject {
	@NSManaged public var filename: String
	@NSManaged public var vCardString: String
	@NSManaged public var color: String
	static var entityName: String { return "ContactCard" }
}
func setFields(contactCardMO: ContactCardMO, filename: String, cnContact: CNContact, color: String) {
	contactCardMO.filename=filename
	contactCardMO.vCardString=ContactDataConverter.cnContactToVCardString(cnContact: cnContact)
	//contactCardMO.uuidString=UUID().uuidString
	contactCardMO.color=color
}
func setContact(contactCardMO: ContactCardMO, cnContact: CNContact) {
	contactCardMO.vCardString=ContactDataConverter.cnContactToVCardString(cnContact: cnContact)
}
