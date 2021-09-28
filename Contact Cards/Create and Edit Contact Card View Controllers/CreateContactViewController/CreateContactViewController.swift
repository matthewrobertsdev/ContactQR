//
//  CreateContactViewController.swift
//  Contact Cards
//
//  Created by Matt Roberts on 12/17/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//
import UIKit
import Contacts
import CoreData
import WidgetKit
class CreateContactViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	//choose title label
	@IBOutlet weak var chooseTitleLabel: UILabel!
	//title text field
	@IBOutlet weak var titleTextField: UITextField!
	//colorsCollectionView
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
	let managedObjectContext=(UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
	@IBAction func cancel(_ sender: Any) {
		dismiss(animated: true)
	}
	@IBAction func saveContact(_ sender: Any) {
		let title=titleTextField.text
		guard let title=title else {
			return
		}
		let titleCopy=title
		if titleCopy.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)=="" {
			let emptyTitleMessage="Card title must not be blank."
			let emptyTitleAlert = UIAlertController(title: "Title Required",
												message: emptyTitleMessage, preferredStyle: .alert)
			let emptyTitleAction=UIAlertAction(title: NSLocalizedString("Got it.",
																	comment: "Empty title Action"), style: .default, handler: { [weak self] _ in
																		  guard let strongSelf=self else {
																			  return
											}
				strongSelf.fieldsScrollView.scrollRectToVisible(strongSelf.chooseTitleLabel.frame, animated: true)
			})
			emptyTitleAlert.addAction(emptyTitleAction)
			emptyTitleAlert.preferredAction=emptyTitleAction
			self.navigationController?.present(emptyTitleAlert, animated: true, completion: nil)
			print("Title was empty")
			return
		}
		let contact=getContactFromFields()
		if forEditing==false {
			guard let context=self.managedObjectContext else {
				return
			}
			let card=NSEntityDescription.entity(forEntityName: ContactCardMO.entityName, in: context)
			guard let card=card else {
				return
			}
			contactCard=ContactCardMO(entity: card, insertInto: context)
		}
		guard let card=contactCard else {
			return
		}
		let index=colorCollectionView.indexPathsForSelectedItems?.first?.item
			guard let index=index else {
				return
			}
		let color=colorModel.colors[index]
		setFields(contactCardMO: card, filename: title, cnContact: contact, color: color.name)
			let managedObjectContext=(UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
			do {
				try managedObjectContext?.save()
			} catch {
				present(localErrorSavingAlertController(), animated: true)
				print("Couldn't save contact")
			}
			NotificationCenter.default.post(name: .contactUpdated, object: self, userInfo: ["uuid": self.contactCard?.objectID.uriRepresentation().absoluteString ?? ""])
			UserDefaults(suiteName: "group.com.apps.celeritas.contact.cards")?.setValue(UUID().uuidString, forKey: "lastUpdateUUID")
			navigationController?.dismiss(animated: true)
			ActiveContactCard.shared.contactCard=card
			NotificationCenter.default.post(name: .contactCreated, object: self, userInfo: nil)
			updateWidget(contactCard: self.contactCard)
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
		colorCollectionView.delegate=self
		colorCollectionView.dataSource=self
		if forEditing {
			navigationItem.title="Edit Card"
			guard let contactCardMO=contactCard else {
				return
			}
			titleTextField.text=contactCardMO.filename
			let index=colorModel.colors.firstIndex(where: { color in
				color.name==contactCardMO.color
			})
			guard let index=index else {
				return
			}
			colorCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
			titleTextField.textColor=colorModel.colors[index].color
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
		let color=colorModel.colors[indexPath.row]
		cell.circularColorView.backgroundColor=color.color
		cell.isAccessibilityElement=true
		cell.accessibilityLabel=color.name
		return cell
	}
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let index=indexPath.item
		titleTextField.textColor=colorModel.colors[index].color
	}
	override func viewWillLayoutSubviews() {
	   super.viewWillLayoutSubviews()
	   self.colorCollectionView.collectionViewLayout.invalidateLayout()
	}
}
