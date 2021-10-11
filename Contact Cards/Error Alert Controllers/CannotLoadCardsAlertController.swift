//
//  CannotLoadCardsAlertController.swift
//  Contact Cards
//
//  Created by Matt Roberts on 7/14/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import UIKit
func cannotLoadCardsAlertController() -> UIAlertController {
	let errorMessage="The file is in the wrong format or is corrupted."
	let cannotEditAlertController=UIAlertController(title: "File Formatted Wrong", message: errorMessage, preferredStyle: .alert)
	let alertAction=UIAlertAction(title: "Got it.", style: .default) { _ in
		cannotEditAlertController.dismiss(animated: true)
	}
	cannotEditAlertController.addAction(alertAction)
	cannotEditAlertController.preferredAction=alertAction
	return cannotEditAlertController
}
