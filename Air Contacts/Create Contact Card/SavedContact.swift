//
//  SavedContact.swift
//  ContactExchange
//
//  Created by Matt Roberts on 6/14/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//

import Foundation
import Contacts

class SavedContact: Codable {
    var filename=""
    var vCardString=""
    init(name: String, cnContact: CNContact) {
        filename=name
        vCardString=ContactDataConverter.cnContactToVCardString(cnContact: cnContact)
    }
}
