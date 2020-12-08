//
//  ContactCardViewController.swift
//  Air Contacts
//
//  Created by Matt Roberts on 11/13/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import UIKit
import Contacts
class ContactCardViewController: UIViewController, UIActivityItemsConfigurationReading {
	var itemProvidersForActivityItemsConfiguration=[NSItemProvider]()
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var contactInfoLabel: UILabel!
	var contactCard: ContactCard?
	let colorModel=ColorModel()
	private var contactDisplayStrings=[String]()
    override func viewDidLoad() {
        super.viewDidLoad()
		guard let appdelegate=UIApplication.shared.delegate as? AppDelegate else {
			return
		}
		appdelegate.activityItemsConfiguration=self
		let shareBarButtonItem=UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"),
											   style: .plain, target: self, action: #selector(shareContact))
		let qrCodeBarButtonItem=UIBarButtonItem(image: UIImage(systemName: "qrcode"), style: .plain,
												target: self, action: #selector(showQRCodeViewController))
		#if targetEnvironment(macCatalyst)
		let docBarButtonItem=UIBarButtonItem(image: UIImage(systemName:
																"doc.badge.plus"), style: .plain, target: self, action: #selector(exportVCardtoFile))
		navigationItem.leftBarButtonItems=[docBarButtonItem]
		#endif
		navigationItem.rightBarButtonItems=[shareBarButtonItem, qrCodeBarButtonItem]
		navigationItem.title=""
		navigationItem.largeTitleDisplayMode = .never
		//tableView.dataSource=self
		loadContact()
		let notificationCenter=NotificationCenter.default
		notificationCenter.addObserver(self, selector: #selector(loadContact), name: .contactChanged, object: nil)
		notificationCenter.addObserver(self, selector: #selector(exportVCardtoFile), name: .exportAsVCard, object: nil)
		notificationCenter.addObserver(self, selector: #selector(showQRCodeViewController), name: .showQRCode, object: nil)
		notificationCenter.addObserver(self, selector: #selector(createNewContact), name: .createNewContact, object: nil)
		notificationCenter.addObserver(self, selector: #selector(createContactCardFromContact), name: .createNewContactFromContact, object: nil)
		notificationCenter.addObserver(self, selector: #selector(loadContact), name: .modalityChanged, object: nil)
		notificationCenter.addObserver(self, selector: #selector(deleteContact), name: .deleteContact, object: nil)
		notificationCenter.addObserver(self, selector: #selector(editContact), name: .editContact, object: nil)
    }
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setToolbarHidden(false, animated: true)
		#if targetEnvironment(macCatalyst)
			navigationController?.setNavigationBarHidden(true, animated: animated)
			navigationController?.setToolbarHidden(true, animated: animated)
		#endif
	}
	override var canBecomeFirstResponder: Bool {
		return true
	}
	func showOrHideTableView() {
		if contactCard==nil {
			scrollView.isHidden=true
		} else {
			scrollView.isHidden=false
		}
	}
	@objc func loadContact() {
		guard let activeCard=ActiveContactCard.shared.contactCard else {
			#if targetEnvironment(macCatalyst)
			SceneDelegate.enableValidToolbarItems()
			#endif
			contactCard=nil
			scrollView.isHidden=true
			titleLabel.text=""
			itemProvidersForActivityItemsConfiguration=[NSItemProvider]()
			return
		}
		contactCard=activeCard
		#if targetEnvironment(macCatalyst)
		SceneDelegate.enableValidToolbarItems()
		#endif
		scrollView.isHidden=false
		titleLabel.text=activeCard.filename
		if let color=colorModel.colorsDictionary[activeCard.color] as? UIColor {
			titleLabel.textColor=color
		}
		do {
			let contact=try ContactDataConverter.createCNContactArray(vCardString: activeCard.vCardString)[0]
			contactInfoLabel.text=ContactInfoManipulator.makeContactDisplayString(cnContact: contact)
			//tableView.reloadData()
		} catch {
			print("Error making CNContact from VCard String.")
		}
		if AppState.shared.appState==AppStateValue.isNotModal {
			guard let fileURL=writeTemporaryFile(contactCard: activeCard) else {
				return
			}
			guard let itemProvider=NSItemProvider(contentsOf: fileURL) else {
				return
			}
			itemProvidersForActivityItemsConfiguration=[itemProvider]
		} else {
			itemProvidersForActivityItemsConfiguration=[NSItemProvider]()
		}
	}
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
	/*
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return contactDisplayStrings.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell=tableView.dequeueReusableCell(withIdentifier: "ContactInfoTableViewCell") as?
			ContactInfoTableViewCell else {
			return UITableViewCell()
		}
		cell.infoLabel.text=contactDisplayStrings[indexPath.row]
		return cell
	}
*/
	@objc func showQRCodeViewController() {
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
		self.present(navigationController, animated: animated) {
		}
	}
	@objc func shareContact(sender: Any?) {
		guard let contactCard=contactCard else {
			return
		}
		guard let fileURL=writeTemporaryFile(contactCard: contactCard) else {
			return
		}
			let activityViewController = UIActivityViewController(
				activityItems: [fileURL],
				applicationActivities: nil
			)
			activityViewController.popoverPresentationController?.barButtonItem=sender as? UIBarButtonItem

			present(activityViewController, animated: true)
	}
	@IBAction func deleteContact(_ sender: Any) {
		guard let uuidString=contactCard?.uuidString else {
			print("Error trying to getting UUID to delete with")
			return
		}
		guard let title=contactCard?.filename else {
			print("Error trying to getting filename for delete message")
			return
		}
		let deleteMessage="Are you sure you want to delete Contact Card with title \"\(title)\"?"
		let deleteAlert = UIAlertController(title: "Are you sure?",
											message: deleteMessage, preferredStyle: .alert)
		deleteAlert.addAction(UIAlertAction(title: NSLocalizedString("Cancel",
																	 comment: "Cancel Delete"), style: .default))
		deleteAlert.addAction(UIAlertAction(title: NSLocalizedString("Delete",
																	 comment: "Delete ACtion"), style: .destructive, handler: { [weak self] _ in
																		guard let strongSelf=self else {
																			return
																		}
			if let deletedIndex=ContactCardStore.sharedInstance.removeContactWithUUID(uuid: uuidString) {
				NotificationCenter.default.post(name: .contactDeleted, object: nil, userInfo: ["index": deletedIndex])
				ActiveContactCard.shared.contactCard=nil
				strongSelf.contactCard=nil
				strongSelf.loadContact()
			}
		}))
		self.present(deleteAlert, animated: true, completion: nil)
	}
	@objc func exportVCardtoFile() {
		guard let contactCard=contactCard else {
			return
		}
		guard let fileURL=writeTemporaryFile(contactCard: contactCard) else {
			print("Couldn't write temporary vCard file")
			return
		}
		let exportContactCardViewController = ExportContactCardViewController(forExporting: [fileURL], asCopy: false)
		exportContactCardViewController.url=fileURL
		present(exportContactCardViewController, animated: true)
	}
	func writeTemporaryFile(contactCard: ContactCard) -> URL? {
		guard let directoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
				return nil
			}
		var filename="Contact"
		var contact=CNContact()
		do {
			contact=try ContactDataConverter.createCNContactArray(vCardString: contactCard.vCardString)[0]
			//tableView.reloadData()
		} catch {
			print("Error making CNContact from VCard String.")
		}
		if let name=CNContactFormatter().string(from: contact) {
			filename=name
		}
		let fileURL = directoryURL.appendingPathComponent(filename)
			.appendingPathExtension("vcf")
		do {
		let data = try CNContactVCardSerialization.data(with: [contact])

		try data.write(to: fileURL, options: [.atomicWrite])
		} catch {
			print("Error trying to make vCard file")
			return nil
		}
		return fileURL
	}
	@objc func share(_ sender: Any?) {
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
	@IBAction func editContact(_ sender: Any) {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		guard let createContactViewController=storyboard.instantiateViewController(withIdentifier:
																					"EditContactCardViewController") as? EditContactCardViewController else {
			print("Failed to instantiate EditContactCardViewController")
			return
		}
		let navigationController=UINavigationController(rootViewController: createContactViewController)
		var animated=true
		#if targetEnvironment(macCatalyst)
			animated=false
		#endif
		present(navigationController, animated: animated)
	}
	override var keyCommands: [UIKeyCommand]? {
		if AppState.shared.appState==AppStateValue.isModal {
			return nil
		}
		var keyCommands=[
			UIKeyCommand(input: "n", modifierFlags: .command, action: #selector(createNewContact),
	discoverabilityTitle: "Create New Contact"),
			UIKeyCommand(input: "n", modifierFlags: UIKeyModifierFlags(arrayLiteral: [.command,.shift]), action:
	#selector(createContactCardFromContact), discoverabilityTitle: "Create New Card From Contact")
		]
		if let _=contactCard {
			keyCommands.append(UIKeyCommand(input: "1", modifierFlags: .command, action:
	#selector(showQRCodeViewController), discoverabilityTitle: "Show QR Code"))
		}
		return keyCommands
	}
}
extension Notification.Name {
	static let contactDeleted=Notification.Name("contact-deleted")
	static let modalityChanged=Notification.Name("modality-changed")
}
