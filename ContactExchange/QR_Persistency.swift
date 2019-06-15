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
    
    private let SAVED_CONTACTS_STRING="saved_contacts"
    
    private let ACTIVE_CONTACT_STRING="active_contact"
    
    static let shared=QR_Persistency()
    
    private init(){
        
    }
    
    func saveContacts(contactsToSave: [SavedContact]) throws{
        let data=try PersistenceManager.shared.encoder.encode(contactsToSave)
        try PersistenceManager.shared.saveData(appendingPath: SAVED_CONTACTS_STRING, dataToSave: data)
    }
    
    func saveActiveContact(activeContact: CNContact) throws{
        let vCardString=ContactDataConverter.makeVCardData(cnContact: activeContact)
        let data=try PersistenceManager.shared.encoder.encode(vCardString)
        try PersistenceManager.shared.saveData(appendingPath: ACTIVE_CONTACT_STRING, dataToSave: data)
    }
    
    func getSavedContacts()throws ->[SavedContact]?{
        let data=try PersistenceManager.shared.loadData(appendingPath: SAVED_CONTACTS_STRING)
        return try PersistenceManager.shared.decoder.decode([SavedContact].self, from: data!)
    }
    
    func getSavedActiveContact()throws ->CNContact?{
        let data=try PersistenceManager.shared.loadData(appendingPath: ACTIVE_CONTACT_STRING)
        let vCardString=try PersistenceManager.shared.decoder.decode(String.self, from: data!)
        return try ContactDataConverter.createCNContactArray(vCardString: vCardString).first
    }
    
}
