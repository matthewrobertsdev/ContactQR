//
//  SavedContact.swift
//  ContactExchange
//
//  Created by Matt Roberts on 6/14/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//

import Foundation
import Contacts

class ContactCard: Codable {
    var filename=""
    var vCardString=""
	var color=ColorChoice.contrastingColor.rawValue
	var uuidString: String?
	init(filename: String, cnContact: CNContact, color: String) {
		self.filename=filename
        vCardString=ContactDataConverter.cnContactToVCardString(cnContact: cnContact)
		uuidString=UUID().uuidString
		self.color=color
    }
}
