//
//  CreateContactViewController.swift
//  Contact Cards
//
//  Created by Matt Roberts on 12/17/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//
import UIKit
import Contacts
import WidgetKit
class CreateContactViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	@IBOutlet weak var colorCollectionView: UICollectionView!
	//name text fields
	@IBOutlet weak var firstNameTextField: UITextField!
	@IBOutlet weak var lastNameTextField: UITextField!
	@IBOutlet weak var prefixTextField: UITextField!
	@IBOutlet weak var suffixTextField: UITextField!
	@IBOutlet weak var nicknameTextField: UITextField!
	//company text fields
	@IBOutlet weak var companyTextField: UITextField!
	@IBOutlet weak var jobTitleTextField: UITextField!
	@IBOutlet weak var departmentTextField: UITextField!
	//phone text fields
	@IBOutlet weak var mobilePhoneTextField: UITextField!
	@IBOutlet weak var workPhone1TextField: UITextField!
	@IBOutlet weak var workPhone2TextField: UITextField!
	@IBOutlet weak var homePhoneTextField: UITextField!
	@IBOutlet weak var otherPhoneTextField: UITextField!
	//email text fields
	@IBOutlet weak var homeEmailTextField: UITextField!
	@IBOutlet weak var workEmail1TextField: UITextField!
	@IBOutlet weak var workEmail2TextField: UITextField!
	@IBOutlet weak var otherEmailTextField: UITextField!
	//social profile text fields
	@IBOutlet weak var facebookTextField: UITextField!
	@IBOutlet weak var linkedInTextField: UITextField!
	@IBOutlet weak var twitterTextField: UITextField!
	@IBOutlet weak var whatsAppTextField: UITextField!
	@IBOutlet weak var instagramTextField: UITextField!
	@IBOutlet weak var snapchatTextField: UITextField!
	@IBOutlet weak var pinterestTextField: UITextField!
	//url text fields
	@IBOutlet weak var urlHomeTextField: UITextField!
	@IBOutlet weak var urlWork1TextField: UITextField!
	@IBOutlet weak var urlWork2TextField: UITextField!
	@IBOutlet weak var otherUrl1TextField: UITextField!
	@IBOutlet weak var otherUrl2TextField: UITextField!
	//address text fields
	//home address
	@IBOutlet weak var homeStreetTextField: UITextField!
	@IBOutlet weak var homeCityTextField: UITextField!
	@IBOutlet weak var homeStateTextField: UITextField!
	@IBOutlet weak var homeZipTextField: UITextField!
	//work address
	@IBOutlet weak var workStreetTextField: UITextField!
	@IBOutlet weak var workStateTextField: UITextField!
	@IBOutlet weak var workCityTextField: UITextField!
	@IBOutlet weak var workZipTextField: UITextField!
	//other address
	@IBOutlet weak var otherStreetTextField: UITextField!
	@IBOutlet weak var otherCityTextField: UITextField!
	@IBOutlet weak var otherStateTextField: UITextField!
	@IBOutlet weak var otherZipTextField: UITextField!
	//scroll view
	@IBOutlet weak var fieldsScrollView: UIScrollView!
	//non-GUI properties
	var forEditing=false
	var contact: CNContact?
	var contactCard: ContactCardMO?
	let colorModel=ColorModel()
	@IBAction func cancel(_ sender: Any) {
		dismiss(animated: true)
	}
	@IBAction func createContact(_ sender: Any) {
		let contact=getContactFromFields()
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		guard let chooseColorTableViewController=storyboard.instantiateViewController(withIdentifier:
																						"ChooseColorTableViewController")
				as? ChooseColorTableViewController else {
			print("Failed to instantiate chooseColorTableViewController")
			return
		}
		chooseColorTableViewController.contact=contact
		if forEditing {
			guard let card=contactCard else {
				return
			}
			setContact(contactCardMO: card, cnContact: contact)
			let managedObjectContext=(UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
			do {
				try managedObjectContext?.save()
			} catch {
				present(localErrorSavingAlertController(), animated: true)
				print("Couldn't save color")
			}
			NotificationCenter.default.post(name: .contactUpdated, object: self, userInfo: ["uuid": self.contactCard?.objectID.uriRepresentation().absoluteString ?? ""])
			UserDefaults(suiteName: "group.com.apps.celeritas.contact.cards")?.setValue(UUID().uuidString, forKey: "lastUpdateUUID")
			navigationController?.dismiss(animated: true)
			updateWidget(contactCard: self.contactCard)
		}
		navigationController?.pushViewController(chooseColorTableViewController, animated: true)
	}
	@IBAction func presentContactPicker(_ sender: Any) {
		let pickContactViewController=PickContactViewController()
		pickContactViewController.contactPickedHandler = { [weak self] (contact: CNContact) in
			guard let strongSelf=self else {
				return
			}
			strongSelf.clearFields()
			strongSelf.fillWithContact(contact: contact)
		}
		present(pickContactViewController, animated: true)
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		//colorCollectionView.collectionViewLayout=CollectionViewFlowLayout()
		colorCollectionView.delegate=self
		colorCollectionView.dataSource=self
		fieldsScrollView.keyboardDismissMode = .interactive
		if forEditing {
			navigationItem.leftBarButtonItem?.title="Save"
			navigationItem.title="Edit Card"
		} else {
			colorCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .left)
		}
		if let contact=contact {
			fillWithContact(contact: contact)
		}
		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name:
										UIResponder.keyboardDidHideNotification, object: nil)
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name:
										UIResponder.keyboardDidShowNotification, object: nil)
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		AppState.shared.appState=AppStateValue.isModal
		NotificationCenter.default.post(name: .modalityChanged, object: nil)
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		AppState.shared.appState=AppStateValue.isNotModal
		NotificationCenter.default.post(name: .modalityChanged, object: nil)
	}
	override var canBecomeFirstResponder: Bool {
		return true
	}
	@objc func adjustForKeyboard(notification: Notification) {
		guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
			return
		}
		let keyboardScreenEndFrame = keyboardValue.cgRectValue
		let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
		if notification.name == UIResponder.keyboardWillHideNotification {
			fieldsScrollView.contentInset = .zero
		} else {
			fieldsScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom:
															keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
		}
		fieldsScrollView.scrollIndicatorInsets = fieldsScrollView.contentInset
	}
	func validateURL(proposedURL: String) -> String {
		var validURL=proposedURL
		if !(proposedURL.starts(with: "http://")) && !(proposedURL.starts(with: "https://")) {
			validURL="http://"+proposedURL
		}
		return validURL
	}
	override var keyCommands: [UIKeyCommand]? {
		return [UIKeyCommand(title: "Close", image: nil, action: #selector(cancel(_:)), input: UIKeyCommand.inputEscape,
							 modifierFlags: .command, propertyList: nil, alternates: [], discoverabilityTitle: "Close",
							 attributes: .destructive, state: .on)]
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width  = 27.5
		let height=width
		return CGSize(width: width, height: height)
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

		let totalCellWidth = 27.5 * Float(collectionView.numberOfItems(inSection: 0))
		let totalSpacingWidth = 2 * Float(collectionView.numberOfItems(inSection: 0) - 1)

		let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
		let rightInset = leftInset

		return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return colorModel.colors.count
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "SelectColorCell", for: indexPath) as? SelectColorCell else {
			return UICollectionViewCell()
		}
		cell.circularColorView.backgroundColor=colorModel.colors[indexPath.row].color
		return cell
	}
	override func viewWillLayoutSubviews() {
	   super.viewWillLayoutSubviews()
	   self.colorCollectionView.collectionViewLayout.invalidateLayout()
	}
}
