//
//  IntentHandler.swift
//  Contact Cards
//
//  Created by Matt Roberts on 3/6/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import Intents
class IntentHandler: INExtension, ConfigurationIntentHandling {
	override func handler(for intent: INIntent) -> Any? {
		return self
	}
	func resolveParameter(for intent: ConfigurationIntent, with completion:
							@escaping (ContactCardINObjectResolutionResult) -> Void) {
		if let parameter=intent.parameter {
			completion(ContactCardINObjectResolutionResult.success(with: parameter))
		}
	}
	func provideParameterOptionsCollection(for intent: ConfigurationIntent, with completion: @escaping
											(INObjectCollection<ContactCardINObject>?, Error?) -> Void) {
		let contactCardINObjects=[ContactCardINObject(identifier: "abcd", display: "hello")]
		let collection = INObjectCollection(items: contactCardINObjects)
		completion(collection, nil)
	}
}
