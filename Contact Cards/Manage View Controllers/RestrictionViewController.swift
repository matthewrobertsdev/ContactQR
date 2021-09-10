//
//  RestrictionViewController.swift
//  Contact Cards
//
//  Created by Matt Roberts on 9/9/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import UIKit
import CloudKit
class RestrictionViewController: UIViewController, UITextFieldDelegate {
	@IBOutlet weak var restrictionStatusTextField: UILabel!
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var restrictTextField: UITextField!
	@IBOutlet weak var unrestrictTextField: UITextField!
	override func viewDidLoad() {
        super.viewDidLoad()
		restrictTextField.delegate=self
		unrestrictTextField.delegate=self
		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name:
										UIResponder.keyboardWillHideNotification, object: nil)
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name:
										UIResponder.keyboardWillChangeFrameNotification, object: nil)
		CKContainer.default().accountStatus { [weak self] (accountStatus, _) in
			guard let strongSelf=self else {
				return
			}
			DispatchQueue.main.async {
			switch accountStatus {
			case .available:
				print("iCloud available")
				strongSelf.restrictionStatusTextField.text="iCloud not restricted"
			case .noAccount:
				print("iCloud no Account")
				strongSelf.restrictionStatusTextField.text="No iCloud account"
			case .couldNotDetermine:
				print("could not determine iCLoud status")
				strongSelf.restrictionStatusTextField.text="Could not determine iCloud status"
			case .restricted:
				print("iCloud restricted")
				strongSelf.restrictionStatusTextField.text="iCloud is restricted"
			@unknown default:
				print("could not determine iCloud status")
				strongSelf.restrictionStatusTextField.text="Could not determine iCloud status"
			}
			}
		}
        // Do any additional setup after loading the view.
    }
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
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
