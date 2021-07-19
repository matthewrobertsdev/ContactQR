//
//  ShowErrorSavingControllers.swift
//  Contact Cards
//
//  Created by Matt Roberts on 7/2/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import UIKit
func localErrorSavingAlertController() -> UIAlertController {
	var errorMessage="An error occurred while saving your changes.  They may not be present in widgets, the messages app, or siri or after the application is quit or terminated."
	#if targetEnvironment(macCatalyst)
	errorMessage="An error occurred while saving your changes.  They may not be present in widgets. or after the application is quit or terminated."
	#endif
	let errorSavingAlertController=UIAlertController(title: "Error Saving Changes", message: errorMessage, preferredStyle: .alert)
	let alertAction=UIAlertAction(title: "Got it.", style: .destructive) { _ in
		errorSavingAlertController.dismiss(animated: true)
	}
	errorSavingAlertController.addAction(alertAction)
	errorSavingAlertController.preferredAction=alertAction
	return errorSavingAlertController
}
func iCloudErrorSavingAlertController() -> UIAlertController {
	var errorMessage="An error occurred while saving changes from iCloud.  They may not be present in widgets, the messages app, or siri or after the application is quit or terminated."
	#if targetEnvironment(macCatalyst)
	errorMessage="An error occurred while saving changes from iCloud.  They may not be present in widgets. or after the application is quit or terminated."
	#endif
	let errorSavingAlertController=UIAlertController(title: "Error Saving Changes from iCloud", message: errorMessage, preferredStyle: .alert)
	let alertAction=UIAlertAction(title: "Got it.", style: .destructive) { _ in
		errorSavingAlertController.dismiss(animated: true)
	}
	errorSavingAlertController.addAction(alertAction)
	errorSavingAlertController.preferredAction=alertAction
	return errorSavingAlertController
}
