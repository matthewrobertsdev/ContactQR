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
	@NSManaged var filename: String?
	@NSManaged var vCardString: String?
	@NSManaged var color: String?
	@NSManaged var uuidString: String?
	func setFields(filename: String, cnContact: CNContact, color: String) {
		self.filename=filename
		vCardString=ContactDataConverter.cnContactToVCardString(cnContact: cnContact)
		uuidString=UUID().uuidString
		self.color=color
	}
	func setContact(cnContact: CNContact) {
		vCardString=ContactDataConverter.cnContactToVCardString(cnContact: cnContact)
	}
	
	static var entityName: String { return "ContactCard" }
}
