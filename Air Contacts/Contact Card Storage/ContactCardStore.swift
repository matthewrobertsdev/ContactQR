//
//  ContactCardStore.swift
//  Air Contacts
//
//  Created by Matt Roberts on 11/14/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import Foundation
import Contacts
class ContactCardStore {
	static let sharedInstance=ContactCardStore()
	var contactCards=[ContactCard]()
	private init(){
		loadContacts()
	}
	func saveContacts() {
		do {
			try ContactCardPersistencyManager.shared.saveContacts(contactsToSave: contactCards)
		} catch {
			print("Error trying to save contact contact cards")
		}
	}
	func loadContacts() {
		do {
			contactCards=try ContactCardPersistencyManager.shared.getSavedContacts()
		} catch {
			print("Error trying to save load contact cards")
		}
	}
	func removeContactWithUUID(uuid: String) -> Int? {
		if let index=contactCards.firstIndex(where: { (currentCard) -> Bool in
			return currentCard.uuidString==uuid
		}) {
			contactCards.remove(at: index)
			saveContacts()
			return index
		}
		return nil
	}
}
