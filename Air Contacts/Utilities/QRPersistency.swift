//
//  QR_Persistency.swift
//  ContactExchange
//
//  Created by Matt Roberts on 6/14/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//
import Foundation
import Contacts
class QRPersistency {
    private let SAVEDCONTACTSFILENAME="saved_contacts.json"
    private let ACTIVECONTACTFILENAME="active_contact.json"
    static let shared=QRPersistency()
    private init() {
    }
    func testEncodeAndDecode(contactsToSave: [ContactCard]) throws {
        print("--------------------")
        for contact in contactsToSave {
            print(contact.vCardString.description)
        }
        let data=try PersistenceManager.shared.encoder.encode(contactsToSave)
        print(String(data: data, encoding: .utf8)!)
        let savedContacts=try PersistenceManager.shared.decoder.decode([ContactCard].self, from: data)
        for contact in savedContacts {
            print(contact.vCardString.description)
        }
        print("--------------------")
    }
    func saveContacts(contactsToSave: [ContactCard]) throws {
        let data: Data=try PersistenceManager.shared.encoder.encode(contactsToSave)
        try PersistenceManager.shared.saveData(appendingPath: SAVEDCONTACTSFILENAME, data: data)
    }
    func getSavedContacts()throws -> [ContactCard] {
        let data=try PersistenceManager.shared.loadData(appendingPath: SAVEDCONTACTSFILENAME)
        if data==nil {
            return [ContactCard]()
        }
        let savedContacts=try PersistenceManager.shared.decoder.decode([ContactCard].self, from: data!)
        return savedContacts
    }
}
