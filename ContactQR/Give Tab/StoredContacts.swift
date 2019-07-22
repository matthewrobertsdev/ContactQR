//
//  SavedContacts.swift
//  ContactExchange
//
//  Created by Matt Roberts on 6/14/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//

import Foundation

class StoredContacts {
    //shared is the singleton
    static let shared=StoredContacts()
    var contacts: [SavedContact]
    var badLoad=false
    private init() {
        do {
            contacts=try QRPersistency.shared.getSavedContacts()
            print("Loaded contacts")
        } catch {
            print("Failed to load contacts or none were there to load "+error.localizedDescription)
            contacts=[SavedContact]()
            print("Added empty contacts")
        }
    }
    func tryToSave() {
            do {
                print("trying to save contacts")
                try QRPersistency.shared.saveContacts(contactsToSave: contacts)
                print("saved contacts")
            } catch {
                print("Failed to save contacts "+error.localizedDescription)
            }
    }
    func testEncodeAndDecode() {
        do {
            try QRPersistency.shared.testEncodeAndDecode(contactsToSave: contacts)
        } catch {
            print("Error trying to encode and decode contacts. "+error.localizedDescription)
        }
    }
}
