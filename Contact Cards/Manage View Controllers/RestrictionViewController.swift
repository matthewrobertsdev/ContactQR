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
        // Do any additional setup after loading the view.
    }
	@IBAction func tryToRestrict(_ sender: Any) {
		if restrictTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()=="restrict" {
			restrictICloud()
		} else {
			let unconfirmedMessage="You have not confirmed that you want to restrict access to iCloud for Contact Cards by typing \"restrict\"."
			let unconfirmedAlertController=UIAlertController(title: "Not Confirmed", message: unconfirmedMessage, preferredStyle: .alert)
			let gotItAction=UIAlertAction(title: "Got it.", style: .default, handler: { _ in
				unconfirmedAlertController.dismiss(animated: true)
			})
			unconfirmedAlertController.addAction(gotItAction)
			unconfirmedAlertController.preferredAction=gotItAction
			present(unconfirmedAlertController, animated: true)
		}
	}
	func restrictICloud() {
		let container=CKContainer(identifier: "iCloud.com.apps.celeritas.ContactCards")
		let apiToken="5065dbfcc540600ae42664510115173f5d7a048169cf55f27d948246adba737a"
			let fetchAuthorization = CKFetchWebAuthTokenOperation(apiToken: apiToken)
			fetchAuthorization.fetchWebAuthTokenCompletionBlock = { [weak self] webToken, error in
				guard let strongSelf = self else {
					return
				}
				guard let webToken = webToken, error == nil else {
					print("No web token")
					return
				}
				strongSelf.restrict(container: container, apiToken: apiToken, webToken: webToken) { error in
					if let error=error {
						print("Restriction failed. Reason: ", error)
						DispatchQueue.main.async {
							let failureAlertController=UIAlertController(title: "Restriction failed", message: "Failed to restrict access to iCloud.", preferredStyle: .alert)
							let gotItAction=UIAlertAction(title: "Got it", style: .default)
							failureAlertController.addAction(gotItAction)
							failureAlertController.preferredAction=gotItAction
							strongSelf.present(failureAlertController, animated: true)
						}
						 return
					} else {
						print("Restriction succeeded.")
						DispatchQueue.main.async {
							let successMessage="Your iCloud access for Contact Cards is now restricted.  Use the un-restrict button to allow access again at any time."
							let successAlertController=UIAlertController(title: "Restriction succeeeded.", message: successMessage, preferredStyle: .alert)
							let gotItAction=UIAlertAction(title: "Got it.", style: .default)
							successAlertController.addAction(gotItAction)
							successAlertController.preferredAction=gotItAction
							strongSelf.present(successAlertController, animated: true)
						}
					}
				}
			}
			container.privateCloudDatabase.add(fetchAuthorization)
	}
	func requestRestriction(url: URL, completionHandler: @escaping (Error?) -> Void) {
		let task = URLSession.shared.dataTask(with: url) { data, response, error in
			if let error = error {
				completionHandler(error)
				return
			}
			guard let httpResponse = response as? HTTPURLResponse,
				(200...299).contains(httpResponse.statusCode) else {
					completionHandler(RestrictError.failure)
					return
			}
			print("Restrict result", httpResponse)
			// Other than indicating success or failure, the `restrict` API doesn't return actionable data in its response.
			if data != nil {
				completionHandler(nil)
			} else {
				completionHandler(RestrictError.failure)
			}
		}
		task.resume()
	}

	/// A utility function that percent encodes a token for URL requests.
	func encodeToken(_ token: String) -> String {
		return token.addingPercentEncoding(
			withAllowedCharacters: CharacterSet(charactersIn: "+/=").inverted
		) ?? token
	}

	/// An error type that represents a failure in the `restrict` API call.
	enum RestrictError: Error {
		case failure
	}

	func restrict(container: CKContainer, apiToken: String, webToken: String, completionHandler: @escaping (Error?) -> Void) {
		let webToken = encodeToken(webToken)
		let identifier = container.containerIdentifier!
		let env = "development" // Use "development" during development.
		let baseURL = "https://api.apple-cloudkit.com/database/1/"
		let apiPath = "\(identifier)/\(env)/private/users/restrict"
		let query = "?ckAPIToken=\(apiToken)&ckWebAuthToken=\(webToken)"
		let url = URL(string: "\(baseURL)\(apiPath)\(query)")!
		requestRestriction(url: url, completionHandler: completionHandler)
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
