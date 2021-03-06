//
//  LoadDocumentViewController.swift
//  Contact Cards
//
//  Created by Matt Roberts on 5/20/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import UIKit
import UniformTypeIdentifiers
class LoadDocumentController: NSObject, UIDocumentPickerDelegate {
	private var pickerViewController: UIDocumentPickerViewController?
	private weak var presentationController: UIViewController?
	var loadHandler = {(url: URL) -> Void in }
	var affectsModality=true
	init(presentationController: UIViewController, forOpeningContentTypes: [UTType]) {
			super.init()
			self.presentationController = presentationController
			self.pickerViewController = UIDocumentPickerViewController(forOpeningContentTypes: forOpeningContentTypes)
		self.pickerViewController?.allowsMultipleSelection=false
		self.pickerViewController?.delegate=self
		if affectsModality {
			AppState.shared.appState=AppStateValue.isModal
			NotificationCenter.default.post(name: .modalityChanged, object: nil)
		}
	}
	func presentPicker() {
		if let controller=pickerViewController {
			self.presentationController?.present(controller, animated: true)
		}
	}
	func documentPicker(_ controller: UIDocumentPickerViewController,
						didPickDocumentsAt urls: [URL]) {
		pickerViewController?.dismiss(animated: true)
		if affectsModality {
			AppState.shared.appState=AppStateValue.isNotModal
			NotificationCenter.default.post(
				name: .modalityChanged, object: nil)
		}
		if let url=urls.first {
			loadHandler(url)
		}
	}
	func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
		pickerViewController?.dismiss(animated: true)
		AppState.shared.appState=AppStateValue.isNotModal
		NotificationCenter.default.post(name: .modalityChanged, object: nil)
	}
}
