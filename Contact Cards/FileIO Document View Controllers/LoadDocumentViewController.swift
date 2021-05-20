//
//  LoadDocumentViewController.swift
//  Contact Cards
//
//  Created by Matt Roberts on 5/20/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import UIKit
import UniformTypeIdentifiers
class LoadDocumentViewController: NSObject, UIDocumentPickerDelegate {
	private var pickerViewController: UIDocumentPickerViewController?
	private weak var presentationController: UIViewController?
	init(presentationController: UIViewController) {
			super.init()
			self.presentationController = presentationController
			self.pickerViewController = UIDocumentPickerViewController(forOpeningContentTypes: [UTType]())
		self.pickerViewController?.delegate=self
	}
	func presentPicker() {
		if let controller=pickerViewController {
			self.presentationController?.present(controller, animated: true)
		}
	}
	func documentPicker(_ controller: UIDocumentPickerViewController,
						didPickDocumentsAt urls: [URL]) {
		pickerViewController?.dismiss(animated: true)
	}
	func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
		pickerViewController?.dismiss(animated: true)
	}
	/*
	// MARK: - Navigation
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destination.
		// Pass the selected object to the new view controller.
	}
	*/
}
