//
//  IntentHandler.swift
//  Contact Cards
//
//  Created by Matt Roberts on 3/6/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import Intents
import CoreData
class IntentHandler: INExtension, ConfigurationIntentHandling {
	override func handler(for intent: INIntent) -> Any? {
		return self
	}
	func resolveParameter(for intent: ConfigurationIntent, with completion:
							@escaping (ContactCardINObjectResolutionResult) -> Void) {
		/*
		if let parameter=intent.parameter {
			completion(ContactCardINObjectResolutionResult.success(with: parameter))
		}
*/
	}
	func provideParameterOptionsCollection(for intent: ConfigurationIntent, with completion: @escaping
											(INObjectCollection<ContactCardINObject>?, Error?) -> Void) {
		let container=loadPersistentContainer()
		let managedObjectContext=container.viewContext
		let fetchRequest = NSFetchRequest<ContactCardMO>(entityName: ContactCardMO.entityName)
			do {
				// Execute Fetch Request
				let contactCards = try managedObjectContext.fetch(fetchRequest)
				//let contactCards=[ContactCardMO]()
				let contactCardINObjects=contactCards.map({(contactCard: ContactCardMO) -> ContactCardINObject in
						return ContactCardINObject(identifier: contactCard.objectID.uriRepresentation().absoluteString, display: contactCard.filename)
				})
				let collection = INObjectCollection(items: contactCardINObjects)
				completion(collection, nil)
			}  catch {
				print("Unable to fetch contact cards")
				completion(INObjectCollection(items: [ContactCardINObject]()), nil)
			}
/*
		
		do {
			let contactCardINObjects=try ContactCardPersistencyManager.shared.getSavedContacts().map({ (contactCard) -> ContactCardINObject in
				return ContactCardINObject(identifier: contactCard.uuidString, display: contactCard.filename)
			})
			let collection = INObjectCollection(items: contactCardINObjects)
			completion(collection, nil)
		} catch {
			print("Error getting contact cards from group container")
			completion(INObjectCollection(items: [ContactCardINObject]()), nil)
		}
*/
	}

}
