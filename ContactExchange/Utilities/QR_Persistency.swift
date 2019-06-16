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
    
    private let SAVED_CONTACTS_FILENAME="saved_contacts.json"
    
    private let ACTIVE_CONTACT_FILENAME="active_contact.json"
    
    static let shared=QR_Persistency()
    
    private init(){
        
    }
    
    func testEncodeAndDecode(contactsToSave: [SavedContact]) throws{
        
        print("--------------------")
        for contact in contactsToSave{
            print(contact.vCardString)
        }
        let data=try PersistenceManager.shared.encoder.encode(contactsToSave)
        print(String(data: data, encoding: .utf8)!)
        let savedContacts=try PersistenceManager.shared.decoder.decode([SavedContact].self, from: data)
        for contact in savedContacts{
            print(contact.vCardString)
        }
        print("--------------------")
 
        
    }
    
    /*
    func saveContacts(contactsToSave: [SavedContact]) throws{
        for contact in contactsToSave{
            print(contact.vCardString)
        }
        let data: Data=try PersistenceManager.shared.encoder.encode(contactsToSave)
        //print("hello "+data.description)
        //let dataString=String(data: data, encoding: .utf8)
        try PersistenceManager.shared.saveData(appendingPath: SAVED_CONTACTS_FILENAME, data: data)
        print("Saving done")
    }
    
    func saveActiveContact(activeContact: CNContact) throws{
        let vCardString=ContactDataConverter.makeVCardData(cnContact: activeContact)
        let data=try PersistenceManager.shared.encoder.encode(vCardString)
        //try PersistenceManager.shared.saveData(appendingPath: ACTIVE_CONTACT_FILENAME, dataToSave: data)
    }
    
    func getSavedContacts()throws ->[SavedContact]{
        let data=try PersistenceManager.shared.loadData(appendingPath: SAVED_CONTACTS_FILENAME)
        if (data==nil){
            return [SavedContact]()
        }
        //let data=string!.data(using: .utf8)
        let savedContacts=try PersistenceManager.shared.decoder.decode([SavedContact].self, from: data!)
        return savedContacts
    }
    
    func getSavedActiveContact()throws ->CNContact?{
        //let data=try PersistenceManager.shared.loadData(appendingPath: ACTIVE_CONTACT_FILENAME)
 
        if (data==nil){
            return nil
        }
        let vCardString=try PersistenceManager.shared.decoder.decode(String.self, from: data!)
 
        return CNContact()
        //return try ContactDataConverter.createCNContactArray(vCardString: vCardString).first
    }
 */
 
    func saveContacts(contactsToSave: [SavedContact]) throws{
        for contact in contactsToSave{
            print(contact.vCardString)
        }
        let data: Data=try PersistenceManager.shared.encoder.encode(contactsToSave)
        //let string=String(data: data, encoding: .utf8)
        //try PersistenceManager.shared.saveString(appendingPath: SAVED_CONTACTS_FILENAME, string: string!)
        try PersistenceManager.shared.saveData(appendingPath: SAVED_CONTACTS_FILENAME, data: data)
        print("Saving done")
    }
    
    func getSavedContacts()throws ->[SavedContact]{
        let data=try PersistenceManager.shared.loadData(appendingPath: SAVED_CONTACTS_FILENAME)
        if (data==nil){
            return [SavedContact]()
        }
        //let data=string!.data(using: .utf8)
        let savedContacts=try PersistenceManager.shared.decoder.decode([SavedContact].self, from: data!)
        return savedContacts
    }
    
    
    
}
