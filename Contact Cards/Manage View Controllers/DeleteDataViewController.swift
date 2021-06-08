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
	/*
	// MARK: - Navigation
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	// Get the new view controller using segue.destination.
	// Pass the selected object to the new view controller.
	}
	*/
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
			/*
			let errorAlertViewController=UIAlertController(title: "Error", message: "Unable to delete the records.  Do you have iCLoud enabled for this app and do you have wifi?", preferredStyle: .alert)
			let allRightAction=UIAlertAction(title: "All right.", style: .default, handler: { _ in
				errorAlertViewController.dismiss(animated: true)
			})
			errorAlertViewController.addAction(allRightAction)
			errorAlertViewController.preferredAction=allRightAction
			let successAlertViewController=UIAlertController(title: "Records deleted", message: "All recordfs were successfully deleted", preferredStyle: .alert)
			let gotItAction=UIAlertAction(title: "Got it.", style: .default, handler: { _ in
				successAlertViewController.dismiss(animated: true)
			})
			successAlertViewController.addAction(gotItAction)
			successAlertViewController.preferredAction=gotItAction
			let privateDatabase=CKContainer(identifier: "iCloud.com.apps.celeritas.ContactCards").privateCloudDatabase
			privateDatabase.delete(withRecordZoneID: .init(zoneName: "com.apple.coredata.cloudkit.zone"), completionHandler: {[weak self] (zoneID, error) in
				if let zoneID=zoneID {
					print("zoneID \(zoneID)")
				} else {
					print("zoneID was nil")
				}
				guard let strongSelf=self else {
					return
				}
				if let error = error {
					print("deleting zone error \(error.localizedDescription)")
					DispatchQueue.main.async {
						strongSelf.present(errorAlertViewController, animated: true)
					}
				} else {
					DispatchQueue.main.async {
						strongSelf.present(successAlertViewController, animated: true)
					}
				}
			})
*/
			/*
			container.privateCloudDatabase.fetchAllRecordZones { [weak self] zones, error in
				guard let strongSelf=self else {
					return
				}
					guard let zones = zones, error == nil else {
						print("Error fetching zones.")
						DispatchQueue.main.async {
							strongSelf.present(errorAlertViewController, animated: true)
						}
						return
					}
					let zoneIDs = zones.map { $0.zoneID }
					let deletionOperation = CKModifyRecordZonesOperation(recordZonesToSave: nil, recordZoneIDsToDelete: zoneIDs)
					deletionOperation.modifyRecordZonesCompletionBlock = { _, deletedZones, error in
						guard error == nil else {
							let error = error
							print("Error deleting records.", error)
							DispatchQueue.main.async {
								strongSelf.present(errorAlertViewController, animated: true)
							}
							return
						}

						print("Records successfully deleted in this zone.")
						DispatchQueue.main.async {
							strongSelf.present(successAlertViewController, animated: true)
						}
					}
					container.privateCloudDatabase.add(deletionOperation)
			}
*/
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
