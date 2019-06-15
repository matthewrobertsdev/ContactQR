//
//  PersistenceManager.swift
//  ContactExchange
//
//  Created by Matt Roberts on 6/14/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//

import Foundation

class PersistenceManager{
    
    static let shared=PersistenceManager()
    
    let encoder = JSONEncoder()
    
    let decoder = JSONDecoder()
    
    private init(){
        encoder.outputFormatting = .prettyPrinted
    }
    
    
    func saveData(appendingPath: String, dataToSave: Data) throws{
        let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
        let fileString = documentDirectory.appendingPathComponent(appendingPath).absoluteString
        FileManager.default.createFile(atPath: fileString, contents: dataToSave, attributes: [:])
        
    }
    
    func loadData(appendingPath: String)throws ->Data?{
        let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
        let fileString = documentDirectory.appendingPathComponent(appendingPath).absoluteString
        return FileManager.default.contents(atPath: fileString)
    }
    
}
