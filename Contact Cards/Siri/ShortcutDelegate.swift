//
//  ShortcutDelegate.swift
//  Contact Cards
//
//  Created by Matt Roberts on 5/27/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import UIKit
import IntentsUI
class ShortcutDelegate: NSObject, INUIAddVoiceShortcutButtonDelegate, INUIAddVoiceShortcutViewControllerDelegate, INUIEditVoiceShortcutViewControllerDelegate {
	weak var viewController: UIViewController?
	init(viewController: UIViewController) {
		self.viewController = viewController
	}
	func present(_ addVoiceShortcutViewController:
					INUIAddVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
		print("Should show add shortcut view controller")
		addVoiceShortcutViewController.delegate = self
		viewController?.present(addVoiceShortcutViewController, animated: true, completion: nil)
	}
	func present(_ editVoiceShortcutViewController: INUIEditVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
		print("Should show edit shortcut view controller")
		editVoiceShortcutViewController.delegate = self
		viewController?.present(editVoiceShortcutViewController, animated: true, completion: nil)
	}
	func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
		viewController?.dismiss(animated: true, completion: nil)
	}
	func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
		viewController?.dismiss(animated: true, completion: nil)
	}
	func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didUpdate voiceShortcut: INVoiceShortcut?, error: Error?) {
		viewController?.dismiss(animated: true, completion: nil)
	}
	
	func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
		viewController?.dismiss(animated: true, completion: nil)
	}
	
	func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
		viewController?.dismiss(animated: true, completion: nil)
	}
}
