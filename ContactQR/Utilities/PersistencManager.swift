//
//  PersistenceManager.swift
//  ContactExchange
//
//  Created by Matt Roberts on 6/14/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//

import Foundation

class PersistenceManager {
    static let shared=PersistenceManager()
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    let fileManager=FileManager.default
    private init() {
        encoder.outputFormatting = .prettyPrinted
    }
    func saveData(appendingPath: String, data: Data) throws {
        let path = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = path.appendingPathComponent(appendingPath)
        if fileManager.fileExists(atPath: fileURL.absoluteString) {
        } else {
            FileManager.default.createFile(atPath: fileURL.absoluteString, contents: nil, attributes: [:])
        }
        try data.write(to: fileURL, options: .atomic)
    }
    func loadData(appendingPath: String) throws -> Data? {
        let path = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileURL = path.appendingPathComponent(appendingPath)
       return try Data(contentsOf: fileURL)
    }
    func saveString(appendingPath: String, string: String) throws {
        let path = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = path.appendingPathComponent(appendingPath)
        if FileManager.default.fileExists(atPath: fileURL.absoluteString) {
        } else {
            FileManager.default.createFile(atPath: fileURL.absoluteString, contents: nil, attributes: [:])
        }
        try string.write(to: fileURL, atomically: true, encoding: .utf8)
    }
    func loadString(appendingPath: String) throws ->String? {
        let path = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileURL = path.appendingPathComponent(appendingPath)
        return try String(contentsOf: fileURL, encoding: .utf8)
    }
}
