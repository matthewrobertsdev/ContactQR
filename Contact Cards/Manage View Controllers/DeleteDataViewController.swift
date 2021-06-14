//
//  DeleteDataViewController.swift
//  Contact Cards
//
//  Created by Matt Roberts on 5/23/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import UIKit
import CloudKit
class DeleteDataViewController: UIViewController, UITextFieldDelegate {
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var confirmationTextField: UITextField!
	override func viewDidLoad() {
		super.viewDidLoad()
		confirmationTextField.delegate=self
		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name:
										UIResponder.keyboardWillHideNotification, object: nil)
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name:
										UIResponder.keyboardWillChangeFrameNotification, object: nil)
		// Do any additional setup after loading the view.
	}
	@IBAction func deleteAll(_ sender: Any) {
		if confirmationTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() != "delete" {
			let unconfirmedAlertController=UIAlertController(title: "Not Confirmed", message: "You have not confirmed that you want to delete all cards by typing \"delete\".", preferredStyle: .alert)
			let gotItAction=UIAlertAction(title: "Got it.", style: .default, handler: { _ in
				unconfirmedAlertController.dismiss(animated: true)
			})
			unconfirmedAlertController.addAction(gotItAction)
			unconfirmedAlertController.preferredAction=gotItAction
			present(unconfirmedAlertController, animated: true)
		} else {
			NotificationCenter.default.post(name: .deleteAllCards, object: nil)
		}
	}
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		confirmationTextField.resignFirstResponder()
	}
	@objc func adjustForKeyboard(notification: Notification) {
		guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
			return
		}
		let keyboardScreenEndFrame = keyboardValue.cgRectValue
		let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
		if notification.name == UIResponder.keyboardWillHideNotification {
			scrollView.contentInset = .zero
		} else {
			scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom:
															keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
		}
		scrollView.scrollIndicatorInsets = scrollView.contentInset
	}
}
