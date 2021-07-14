//
//  ContactCardViewController.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/13/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import UIKit
import Contacts
class ContactCardViewController: UIViewController, UIActivityItemsConfigurationReading {
	var itemProvidersForActivityItemsConfiguration=[NSItemProvider]()
	@IBOutlet weak var noCardSelectedLabel: UILabel!
	@IBOutlet weak var stackView: UIStackView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var contactInfoTextView: UITextView!
	@IBOutlet weak var macButtonView: UIView!
	@IBOutlet weak var copyButton: UIButton!
	var contactCard: ContactCardMO?
	let colorModel=ColorModel()
	private var contactDisplayStrings=[String]()
    override func viewDidLoad() {
        super.viewDidLoad()
		guard let appDelegate=UIApplication.shared.delegate as? AppDelegate else {
			return
		}
		appDelegate.activityItemsConfiguration=self
		let newCardButton=UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain,
												target: self, action: #selector(createNewContact))
		#if targetEnvironment(macCatalyst)
		let docBarButtonItem=UIBarButtonItem(image: UIImage(systemName:
																"doc.badge.plus"), style: .plain, target: self, action: #selector(exportVCardtoFile))
		navigationItem.leftBarButtonItems=[docBarButtonItem]
		#endif
		navigationItem.rightBarButtonItems=[newCardButton]
		navigationItem.title="Card"
		navigationItem.largeTitleDisplayMode = .never
		loadContact()
		let notificationCenter=NotificationCenter.default
		notificationCenter.addObserver(self, selector: #selector(loadContact), name: .contactCreated, object: nil)
		notificationCenter.addObserver(self, selector: #selector(loadContact), name: .contactChanged, object: nil)
		notificationCenter.addObserver(self, selector: #selector(exportVCardtoFile), name: .exportAsVCard, object: nil)
		notificationCenter.addObserver(self, selector: #selector(showQRViewController(_:)), name: .showQRCode, object: nil)
		notificationCenter.addObserver(self, selector: #selector(createNewContact), name: .createNewContact, object: nil)
		notificationCenter.addObserver(self, selector: #selector(createContactCardFromContact),
									   name: .createNewContactFromContact, object: nil)
		notificationCenter.addObserver(self, selector: #selector(loadContact), name: .modalityChanged, object: nil)
		notificationCenter.addObserver(self, selector: #selector(deleteContact), name: .deleteContact, object: nil)
		notificationCenter.addObserver(self, selector: #selector(editContact), name: .editContact, object: nil)
		notificationCenter.addObserver(self, selector: #selector(loadContact), name: .contactUpdated, object: nil)
		notificationCenter.addObserver(self, selector: #selector(loadContact), name: .contactDeleted, object: nil)
		notificationCenter.addObserver(self, selector: #selector(editContactInfo), name: .editContactInfo, object: nil)
		notificationCenter.addObserver(self, selector: #selector(editColor), name: .editColor, object: nil)
		notificationCenter.addObserver(self, selector: #selector(editTitle), name: .editTitle, object: nil)
		notificationCenter.addObserver(self, selector: #selector(manageCards), name: .manageCards, object: nil)
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setToolbarHidden(false, animated: true)
		#if targetEnvironment(macCatalyst)
			navigationController?.setNavigationBarHidden(true, animated: animated)
			navigationController?.setToolbarHidden(true, animated: animated)
		#else
			stackView.removeArrangedSubview(macButtonView)
			copyButton.isHidden=true
		#endif
	}
	override var canBecomeFirstResponder: Bool {
		return true
	}
	@IBAction func showQR_Code(_ sender: Any) {
		showQRViewController(sender)
	}
	@IBAction func share(_ sender: Any) {
		shareContact(share)
	}
	@objc func showQRViewController(_ sender: Any) {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		guard let displayQRViewController=storyboard.instantiateViewController(withIdentifier: "DisplayQRViewController")
				as? DisplayQRViewController else {
			print("Failed to instantiate DisplayQRViewController")
			return
		}
		let navigationController=UINavigationController(rootViewController: displayQRViewController)
		var animated=true
		#if targetEnvironment(macCatalyst)
			animated=false
		#endif
		self.present(navigationController, animated: animated)
	}
	@objc func shareContact(_ sender: Any) {
		guard let contactCard=contactCard else {
			return
		}
		guard let directoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
				return
			}
		guard let fileURL=ContactDataConverter.writeTemporaryFile(contactCard: contactCard, directoryURL: directoryURL) else {
			return
		}
			let activityViewController = UIActivityViewController(
				activityItems: [fileURL],
				applicationActivities: nil
			)
			activityViewController.popoverPresentationController?.barButtonItem=sender as? UIBarButtonItem
		activityViewController.popoverPresentationController?.sourceView=navigationController?.toolbar

			present(activityViewController, animated: true)
	}
	@objc public func loadContact() {
		guard let activeCard=ActiveContactCard.shared.contactCard else {
			#if targetEnvironment(macCatalyst)
			SceneDelegate.enableValidToolbarItems()
			#endif
			enableButtons(enable: false)
			contactCard=nil
			titleLabel.isHidden=true
			contactInfoTextView.isHidden=true
			copyButton.isHidden=true
			noCardSelectedLabel.isHidden=false
			titleLabel.text=""
			itemProvidersForActivityItemsConfiguration=[NSItemProvider]()
			return
		}
		contactCard=activeCard
		enableButtons(enable: true)
		#if targetEnvironment(macCatalyst)
		SceneDelegate.enableValidToolbarItems()
		copyButton.isHidden=false
		#endif
		titleLabel.isHidden=false
		contactInfoTextView.isHidden=false
		noCardSelectedLabel.isHidden=true
		titleLabel.text=activeCard.filename
		if let color=colorModel.getColorsDictionary()[activeCard.color] as? UIColor {
			titleLabel.textColor=color
		}
		do {
			let contactArray=try ContactDataConverter.createCNContactArray(vCardString: activeCard.vCardString)
			if contactArray.count==1 {
				contactInfoTextView.attributedText=ContactInfoManipulator.makeContactDisplayString(cnContact: contactArray[0], fontSize: CGFloat(18))
			} else {
				contactInfoTextView.attributedText=NSAttributedString(string: "")
				enableButtons(enable: false)
			}
		} catch {
			print("Error making CNContact from VCard String.")
		}
		guard let directoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
				return
			}
		guard let fileURL=ContactDataConverter.writeTemporaryFile(contactCard: activeCard, directoryURL: directoryURL) else {
			itemProvidersForActivityItemsConfiguration=[NSItemProvider]()
			contactInfoTextView.attributedText=ContactInfoManipulator.getBadVCardAttributedString(fontSize: CGFloat(18))
			return
		}
		guard let itemProvider=NSItemProvider(contentsOf: fileURL) else {
			itemProvidersForActivityItemsConfiguration=[NSItemProvider]()
			contactInfoTextView.attributedText=ContactInfoManipulator.getBadVCardAttributedString(fontSize: CGFloat(18))
			return
		}
		if AppState.shared.appState==AppStateValue.isNotModal {
			itemProvidersForActivityItemsConfiguration=[itemProvider]
		} else {
			itemProvidersForActivityItemsConfiguration=[NSItemProvider]()
		}
	}
	func enableButtons(enable: Bool) {
		guard let toolbarItems=toolbarItems else {
			return
		}
		for item in toolbarItems {
			item.isEnabled=enable
		}
	}
	func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
			UIApplication.shared.open(URL)
			return false
		}
	@IBAction func deleteContact(_ sender: Any) {
		guard let contactCardMO=contactCard else {
			return
		}
		guard let title=contactCard?.filename else {
			print("Error trying to getting filename for delete message")
			return
		}
		let deleteMessage="Are you sure you want to delete Contact Card with title \"\(title)\"?"
		let deleteAlert = UIAlertController(title: "Are you sure?",
											message: deleteMessage, preferredStyle: .alert)
		let cancelAction=UIAlertAction(title: NSLocalizedString("Cancel",
															comment: "Cancel Delete"), style: .default)
		deleteAlert.addAction(cancelAction)
		deleteAlert.addAction(UIAlertAction(title: NSLocalizedString("Delete",
																	 comment: "Delete ACtion"), style: .destructive, handler: { [weak self] _ in
																		guard let strongSelf=self else {
																			return
																		}
																		let managedObjectContext=(UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
																		managedObjectContext?.delete(contactCardMO)
				ActiveContactCard.shared.contactCard=nil
				strongSelf.contactCard=nil
																		strongSelf.loadContact()
																		do {
																			try managedObjectContext?.save()
																		} catch {
																			managedObjectContext?.rollback()
																			strongSelf.present(localErrorSavingAlertController(), animated: true)
																		}
		}))
		deleteAlert.preferredAction=cancelAction
		self.present(deleteAlert, animated: true, completion: nil)
	}
	@objc func exportVCardtoFile() {
		guard let contactCard=contactCard else {
			return
		}
		guard let directoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
				return
			}
		guard let fileURL=ContactDataConverter.writeTemporaryFile(contactCard: contactCard, directoryURL: directoryURL) else {
			print("Couldn't write temporary vCard file")
			return
		}
		let exportContactCardViewController = SaveDocumentViewController(forExporting: [fileURL], asCopy: false)
		exportContactCardViewController.url=fileURL
		present(exportContactCardViewController, animated: true)
	}
	@objc func createNewContact() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		guard let createContactViewController=storyboard.instantiateViewController(withIdentifier:
																					"CreateContactViewController") as? CreateContactViewController else {
			print("Failed to instantiate CreateContactViewController")
			return
		}
		let navigationController=UINavigationController(rootViewController: createContactViewController)
		var animated=true
		#if targetEnvironment(macCatalyst)
			animated=false
		#endif
		present(navigationController, animated: animated)
	}
	@objc func createContactCardFromContact() {
		var animated=true
		#if targetEnvironment(macCatalyst)
			animated=false
		#endif
		self.present(PickContactViewController(), animated: animated) {
		}
	}
	@objc func editContactInfo() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		guard let createContactViewController=storyboard.instantiateViewController(withIdentifier:
																						"CreateContactViewController")
				as? CreateContactViewController else {
			print("Failed to instantiate CreateContactViewController")
			return
		}
		createContactViewController.forEditing=true
		guard let contactCard=contactCard else {
			present(cannotEditAlertController(), animated: true)
			return
		}
		createContactViewController.contactCard=contactCard
		let navigationController=UINavigationController(rootViewController: createContactViewController)
		do {
			let contactArray=try ContactDataConverter.createCNContactArray(vCardString: contactCard.vCardString)
			if contactArray.count==1 {
				createContactViewController.contact=contactArray[0]
				createContactViewController.contactCard=contactCard
			}
		} catch {
			print("Error making CNContact from VCard String.")
		}
		present(navigationController, animated: true)
	}
	@objc func editColor() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		guard let chooseColorTableViewController=storyboard.instantiateViewController(withIdentifier:
																						"ChooseColorTableViewController")
				as? ChooseColorTableViewController else {
			print("Failed to instantiate ChooseColorTableViewController")
			return
		}
		chooseColorTableViewController.forEditing=true
		guard let contactCard=contactCard else {
			present(cannotEditAlertController(), animated: true)
			return
		}
		chooseColorTableViewController.contactCard=contactCard
		let navigationController=UINavigationController(rootViewController: chooseColorTableViewController)
		do {
			let contactArray=try ContactDataConverter.createCNContactArray(vCardString: contactCard.vCardString)
			if contactArray.count==1 {
				chooseColorTableViewController.contact=contactArray[0]
				chooseColorTableViewController.contactCard=contactCard
			}
		} catch {
			print("Error making CNContact from VCard String.")
		}
		present(navigationController, animated: true)
	}
	@objc func editTitle() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		guard let saveContactCardViewController=storyboard.instantiateViewController(withIdentifier:
																						"SaveContactCardViewController")
				as? SaveContactCardViewController else {
			print("Failed to instantiate SaveContactCardViewController")
			return
		}
		saveContactCardViewController.forEditing=true
		guard let contactCard=contactCard else {
			present(cannotEditAlertController(), animated: true)
			return
		}
		saveContactCardViewController.contactCard=contactCard
		let navigationController=UINavigationController(rootViewController: saveContactCardViewController)
		do {
			let contactArray=try ContactDataConverter.createCNContactArray(vCardString: contactCard.vCardString)
			if contactArray.count==1 {
				saveContactCardViewController.contact=contactArray[0]
				saveContactCardViewController.contactCard=contactCard
			}
		} catch {
			print("Error making CNContact from VCard String.")
		}
		present(navigationController, animated: true)
	}
	@objc func manageCards() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		guard let manageCardsViewController=storyboard.instantiateViewController(withIdentifier:
																						"ManageCardsViewController")
				as? ManageCardsViewController else {
			print("Failed to instantiate ManageCardsViewController")
			return
		}
		let navigationController=UINavigationController(rootViewController: manageCardsViewController)
		self.present(navigationController, animated: true)
	}
	@IBAction func editContact(_ sender: Any) {
		let editContactAlertController=EditContactAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		do {
			let contactArray=try ContactDataConverter.createCNContactArray(vCardString: contactCard?.vCardString ?? "")
			if contactArray.count==1 {
				editContactAlertController.contact=contactArray[0]
				editContactAlertController.contactCard=contactCard
			}
		} catch {
			print("Error making CNContact from VCard String.")
		}
		#if targetEnvironment(macCatalyst)
		let popoverPresentationController=editContactAlertController.popoverPresentationController
		popoverPresentationController?.sourceView=self.titleLabel
		popoverPresentationController?.sourceRect=self.titleLabel.frame
		#else
		let popoverPresentationController=editContactAlertController.popoverPresentationController
		popoverPresentationController?.barButtonItem=toolbarItems?.last
		#endif
		present(editContactAlertController, animated: true) {
		}
	}
	@IBAction override func copy(_ sender: Any?) {
		if ActiveContactCard.shared.contactCard != nil {
			copyVCard(self)
		}
	}
	@IBAction func copyVCard(_ sender: Any) {
		let pasteBoard=UIPasteboard.general
		pasteBoard.itemProviders=[]
		guard let activeCard=ActiveContactCard.shared.contactCard else {
			return
		}
		guard var directoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
				return
			}
		directoryURL.appendPathComponent("vCardToCopy")
		do {
		try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
		guard let fileURL=ContactDataConverter.writeTemporaryFile(contactCard: activeCard, directoryURL: directoryURL) else {
			return
		}
			guard let itemProvider=NSItemProvider(contentsOf: fileURL) else {
				return
			}
				pasteBoard.setItemProviders([itemProvider], localOnly: true, expirationDate: nil)
		} catch {
			print("Error creating vCardToCopy directory")
		}
	}
}

extension ContactCardViewController {
	override var keyCommands: [UIKeyCommand]? {
		if AppState.shared.appState==AppStateValue.isModal {
			return nil
		}
		var keyCommands=[UIKeyCommand(title: "Create New Contact", image: nil, action: #selector(createNewContact),
									input: "n", modifierFlags: .command, propertyList: nil, alternates: [], discoverabilityTitle: "Create New Contact",
									attributes: UIKeyCommand.Attributes(), state: .off),
						 UIKeyCommand(title: "Create New Card From Contact", image: nil, action: #selector(createContactCardFromContact),
																										input: "n", modifierFlags: UIKeyModifierFlags(arrayLiteral: [.command,.shift]), propertyList: nil, alternates: [], discoverabilityTitle: "Create New Card From Contact",
													 attributes: UIKeyCommand.Attributes(), state: .off)]
		if contactCard != nil {
			keyCommands.append(UIKeyCommand(title: "Show QR Code", image: nil, action: #selector(showQRViewController(_:)),
											input: "1", modifierFlags: .command, propertyList: nil, alternates: [], discoverabilityTitle: "Show QR Code",
											attributes: UIKeyCommand.Attributes(), state: .off))
		}
		return keyCommands
	}
}
