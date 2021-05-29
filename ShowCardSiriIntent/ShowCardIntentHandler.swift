//
//  ShowCardIntentHandler.swift
//  ShowCardSiriIntent
//
//  Created by Matt Roberts on 5/27/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//

import Foundation
class ShowCardIntentHandler: NSObject, ShowCardIntentHandling {
	func handle(intent: ShowCardIntent, completion: @escaping (ShowCardIntentResponse) -> Void) {
		completion(ShowCardIntentResponse(code: .success, userActivity: nil))
	}
	func confirm(intent: ShowCardIntent, completion: @escaping (ShowCardIntentResponse) -> Void) {
		completion(ShowCardIntentResponse(code: .success, userActivity: nil))
	}
}
