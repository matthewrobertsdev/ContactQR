//
//  SavedContacts.swift
//  ContactExchange
//
//  Created by Matt Roberts on 6/14/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//

import Foundation

class SavedContacts{
    
    //shared is the singleton
    static let shared=SavedContacts()
    
    var savedContacts: [SavedContact]=[]
    
    private init(){
        
    }
    
}
