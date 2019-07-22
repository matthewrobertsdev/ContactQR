//
//  QR_Persistency.swift
//  ContactExchange
//
//  Created by Matt Roberts on 6/14/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//

import Foundation
import Contacts

class QRPersistency{
    
    private let SAVEDCONTACTSFILENAME="saved_contacts.json"
    
    private let ACTIVECONTACTFILENAME="active_contact.json"
    
    static let shared=QRPersistency()
    
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
    func saveActiveContact(activeContact: CNContact) throws{
        let vCardString=ContactDataConverter.makeVCardData(cnContact: activeContact)
        let data=try PersistenceManager.shared.encoder.encode(vCardString)
        //try PersistenceManager.shared.saveData(appendingPath: ACTIVE_CONTACT_FILENAME, dataToSave: data)
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
        try PersistenceManager.shared.saveData(appendingPath: SAVEDCONTACTSFILENAME, data: data)
        print("Saving done")
    }
    
    func getSavedContacts()throws ->[SavedContact]{
        let data=try PersistenceManager.shared.loadData(appendingPath: SAVEDCONTACTSFILENAME)
        if (data==nil){
            return [SavedContact]()
        }
        let savedContacts=try PersistenceManager.shared.decoder.decode([SavedContact].self, from: data!)
        return savedContacts
    }
    
    
    
}
