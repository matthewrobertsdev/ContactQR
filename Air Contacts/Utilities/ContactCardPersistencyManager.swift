//
//  QR_Persistency.swift
//  ContactExchange
//
//  Created by Matt Roberts on 6/14/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//
import Foundation
import Contacts
class ContactCardPersistencyManager {
	private let encoder = JSONEncoder()
	private let decoder = JSONDecoder()
    private let savedContactsFilename="saved_contacts.json"
    private let activeContactsFilename="active_contact.json"
    static let shared=ContactCardPersistencyManager()
	private init() {
		encoder.outputFormatting = .prettyPrinted
	}
    func saveContacts(contactsToSave: [ContactCard]) throws {
        let data: Data=try encoder.encode(contactsToSave)
        try PersistenceManager.shared.saveData(appendingPath: savedContactsFilename, data: data)
    }
    func getSavedContacts()throws -> [ContactCard] {
        let data=try PersistenceManager.shared.loadData(appendingPath: savedContactsFilename)
        if data==nil {
            return [ContactCard]()
        }
        let savedContacts=try decoder.decode([ContactCard].self, from: data!)
        return savedContacts
    }
}
