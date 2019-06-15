//
//  QR_Persistency.swift
//  ContactExchange
//
//  Created by Matt Roberts on 6/14/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//

import Foundation
import Contacts

class QR_Persistency{
    
    let SAVED_CONTACTS_STRING="saved_contacts"
    
    let ACTIVE_CONTACT_STRING="active_contact"
    
    static let shared=QR_Persistency()
    
    private init(){
        
    }
    
    func saveContacts(contactsToSave: [SavedContact]) throws{
        let data=try PersistenceManager.shared.encoder.encode(contactsToSave)
        try PersistenceManager.shared.saveData(appendingPath: SAVED_CONTACTS_STRING, dataToSave: data)
    }
    
    func saveActiveContact(activeContact: SavedContact) throws{
        let data=try PersistenceManager.shared.encoder.encode(activeContact)
        try PersistenceManager.shared.saveData(appendingPath: ACTIVE_CONTACT_STRING, dataToSave: data)
    }
    
    func getSavedContacts()throws ->[SavedContact]?{
        let data=try PersistenceManager.shared.loadData(appendingPath: SAVED_CONTACTS_STRING)
        return try PersistenceManager.shared.decoder.decode([SavedContact].self, from: data!)
    }
    
    func getSavedActiveContact()throws ->[SavedContact]?{
        let data=try PersistenceManager.shared.loadData(appendingPath: ACTIVE_CONTACT_STRING)
        return try PersistenceManager.shared.decoder.decode([SavedContact].self, from: data!)
    }
    
}
