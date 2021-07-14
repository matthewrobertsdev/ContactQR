//
//  CannotEditAlertControllers.swift
//  Contact Cards
//
//  Created by Matt Roberts on 7/14/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import UIKit
func cannotEditAlertController() -> UIAlertController {
	let errorMessage="Please create a card or select a card before trying to edit it."
	let cannotEditAlertController=UIAlertController(title: "No Card Selected", message: errorMessage, preferredStyle: .alert)
	let alertAction=UIAlertAction(title: "Got it.", style: .default) { _ in
		cannotEditAlertController.dismiss(animated: true)
	}
	cannotEditAlertController.addAction(alertAction)
	cannotEditAlertController.preferredAction=alertAction
	return cannotEditAlertController
}
