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
    
    func saveData(appendingPath: String, data: Data) throws{
        let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create:true)
        let fileURL = documentDirectory.appendingPathComponent(appendingPath)
        print("File turl to save to "+fileURL.description)
        if(FileManager.default.fileExists(atPath: fileURL.absoluteString)){
            print("File already existed")
        }
        else{
            FileManager.default.createFile(atPath: fileURL.absoluteString, contents: nil, attributes: [:])
            print("Created file")
        }
        try data.write(to: fileURL, options: .atomic)
        
    }
    
    func loadData(appendingPath: String)throws ->Data?{
        let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create:false)
        let fileURL = documentDirectory.appendingPathComponent(appendingPath)
       return try Data(contentsOf: fileURL)
    }
    
    
    func saveString(appendingPath: String, string: String) throws{
        let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create:true)
        let fileURL = documentDirectory.appendingPathComponent(appendingPath)
        print("File turl to save to "+fileURL.description)
        if(FileManager.default.fileExists(atPath: fileURL.absoluteString)){
            print("File already existed")
        }
        else{
            FileManager.default.createFile(atPath: fileURL.absoluteString, contents: nil, attributes: [:])
            print("Created file")
        }
        try string.write(to: fileURL, atomically: true, encoding: .utf8)
    }
    
    func loadString(appendingPath: String)throws ->String?{
        let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create:false)
        let fileURL = documentDirectory.appendingPathComponent(appendingPath)
        return try String(contentsOf: fileURL, encoding: .utf8)
    }
 
    
}
