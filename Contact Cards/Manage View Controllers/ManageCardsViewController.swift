//
//  ManageCardsViewController.swift
//  Contact Cards
//
//  Created by Matt Roberts on 5/17/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import UIKit
import CoreData
import UniformTypeIdentifiers
class ManageCardsViewController: UIViewController {
	@IBOutlet weak var syncWithCloudStackView: UIStackView!
	@IBOutlet weak var syncSwitch: UISwitch!
	@IBOutlet weak var exportButton: UIButton!
	@IBOutlet weak var exportAsRtfdButton: UIButton!
	let managedObjectContext=(UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
	var loadDocumentController: LoadDocumentController?
    override func viewDidLoad() {
        super.viewDidLoad()
		AppState.shared.appState = .isModal
        // Do any additional setup after loading the view.
		#if targetEnvironment(macCatalyst)
		syncWithCloudStackView.addArrangedSubview(syncWithCloudStackView.arrangedSubviews[0])
		#endif
		setSyncSwitchUI()
		NotificationCenter.default.addObserver(self, selector: #selector(setSyncSwitchUI), name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: nil)
    }
	@IBAction func done(_ sender: Any) {
		self.dismiss(animated: true)
	}
	@IBAction func saveContactCardsArchive(_ sender: Any) {
		guard let persistentContainer=(UIApplication.shared.delegate as? AppDelegate)?.persistentContainer else {
			return
		}
		let managedObjectContext=persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<ContactCardMO>(entityName: ContactCardMO.entityName)
			do {
				var contactCards=[ContactCard]()
				// Execute Fetch Request
				let contactCardMOs = try managedObjectContext.fetch(fetchRequest)
				for index in 0..<contactCardMOs.count {
					if let contactCardMO = try persistentContainer.viewContext.existingObject(with: contactCardMOs[index].objectID) as? ContactCardMO {
						contactCards.append(ContactCard(filename: contactCardMO.filename, vCardString: contactCardMO.vCardString, color: contactCardMO.color))
					}
				}
				let encoder=JSONEncoder()
				encoder.outputFormatting = .prettyPrinted
				guard let directoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
						return
					}
				#if targetEnvironment(macCatalyst)
				if let fileURL=ContactDataConverter.writeArchive(contactCards: contactCards, directoryURL: directoryURL, fileExtension: "txt") {
					let exportContactCardViewController = SaveDocumentViewController(forExporting: [fileURL], asCopy: false)
					exportContactCardViewController.url=fileURL
					present(exportContactCardViewController, animated: true)
				}
					#else
				if let fileURL=ContactDataConverter.writeArchive(contactCards: contactCards, directoryURL: directoryURL, fileExtension: "txt") {
					let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
					activityViewController.popoverPresentationController?.sourceView=exportButton
					present(activityViewController, animated: true, completion: nil)
				}
					#endif
			} catch {
				print("Unable to save contact cards")
			}
	}
	@IBAction func loadContactCardsArchive(_ sender: Any) {
		loadDocumentController=LoadDocumentController(presentationController: self, forOpeningContentTypes:  [UTType.text])
		loadDocumentController?.affectsModality=false
		loadDocumentController?.loadHandler = { [weak self] (url: URL) -> Void in
			guard let strongSelf=self else {
				return
			}
				if let contactCards=ContactDataConverter.readArchive(url: url) {
					for card in contactCards {
						guard let context=strongSelf.managedObjectContext else {
							return
						}
						let contactCardMO=NSEntityDescription.entity(forEntityName: ContactCardMO.entityName, in: context)
						guard let cardMO=contactCardMO else {
							return
						}
						let contactCardRecord=ContactCardMO(entity: cardMO, insertInto: context)
						do {
							let contact=try ContactDataConverter.createCNContactArray(vCardString: card.vCardString)[0]
							setFields(contactCardMO: contactCardRecord, filename: card.filename, cnContact: contact, color: card.color)
						} catch {
							print("Error getting CNContact from vCard")
						}
						do {
							try strongSelf.managedObjectContext?.save()
							strongSelf.managedObjectContext?.rollback()
							let successAlertViewController=UIAlertController(title: "Contact Cards Loaded", message: "All contact cards were successfully loaded.", preferredStyle: .alert)
							let gotItAction=UIAlertAction(title: "Got it.", style: .default, handler: { _ in
								successAlertViewController.dismiss(animated: true)
							})
							successAlertViewController.addAction(gotItAction)
							successAlertViewController.preferredAction=gotItAction
							strongSelf.present(successAlertViewController, animated: true)
							NotificationCenter.default.post(name: .cardsLoaded, object: nil)
						} catch {
							print(error.localizedDescription)
						}
					}
				} else {
					strongSelf.present(cannotLoadCardsAlertController(), animated: true)
				}
				return
			}
			loadDocumentController?.presentPicker()
	}
	@IBAction func exportToRtfdFile(_ sender: Any) {
		let attributedString=ContactCloudDataDescriber.getAttributedStringDescription(color: UIColor.systemBlue)
		guard var fileURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
				return
			}
		do {
			let data = try attributedString?.fileWrapper (from: NSRange (location: 0, length: attributedString?.length ?? 0), documentAttributes: [.documentType: NSAttributedString.DocumentType.rtfd])
			fileURL.appendPathComponent("Contact Cards iCloud Data Description")
			fileURL.appendPathExtension("rtfd")
			try data?.write(to: fileURL, options: .atomic, originalContentsURL: nil)
			#if targetEnvironment(macCatalyst)
			let exportContactCardViewController = SaveDocumentViewController(forExporting: [fileURL], asCopy: false)
			exportContactCardViewController.url=fileURL
			present(exportContactCardViewController, animated: true)
			#else
			let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
			activityViewController.popoverPresentationController?.sourceView=exportAsRtfdButton
			present(activityViewController, animated: true, completion: nil)
			#endif
		} catch {
			print("Error trying to write rtf file")
		}
	}
	func getDocumentsDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return paths[0]
	}
	@IBAction func toggleSync(_ sender: Any) {
		let keyValueStore=NSUbiquitousKeyValueStore.default
		if keyValueStore.bool(forKey: "iCloudSync") {
			toggleSync(sync: false)
			let syncMessage="Sync is now disabled for cards created with this app.  Your data will remain in iCloud unless you turn on sync, delete the data, and then turn sync off again."
			let syncAlertController=UIAlertController(title: "Sync with iCloud Is Now Off", message: syncMessage, preferredStyle: .alert)
			let confirmationAction=UIAlertAction(title: "Got it", style: .default)
			syncAlertController.addAction(confirmationAction)
			syncAlertController.preferredAction=confirmationAction
			present(syncAlertController, animated: true)
		} else {
			toggleSync(sync: true)
			let syncMessage="Your contact cards created with this app will now sync with iCloud."
			let syncAlertController=UIAlertController(title: "Sync with iCloud Is Now On", message: syncMessage, preferredStyle: .alert)
			let confirmationAction=UIAlertAction(title: "Got it", style: .default)
			syncAlertController.addAction(confirmationAction)
			syncAlertController.preferredAction=confirmationAction
			present(syncAlertController, animated: true)
		}
		setSyncSwitchUI()
	}
	func toggleSync(sync: Bool) {
		let keyValueStore=NSUbiquitousKeyValueStore.default
		keyValueStore.set(sync, forKey: "iCloudSync")
		keyValueStore.synchronize()
		UserDefaults(suiteName: appGroupKey)?.setValue(UUID().uuidString, forKey: "syncChangedUUID")
		(UIApplication.shared.delegate as? AppDelegate)?.persistentContainer=loadPersistentContainer(neverSync: false)
		/*
		if let container=(UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
			updatePersistentContainer(container: container, neverSync: false)
		}
*/
		NotificationCenter.default.post(name: .syncChanged, object: nil)
	}
	@objc func setSyncSwitchUI() {
		let keyValueStore=NSUbiquitousKeyValueStore.default
		if keyValueStore.bool(forKey: "iCloudSync") {
			syncSwitch.isOn=true
		} else {
			syncSwitch.isOn=false
		}
	}
	override func viewWillDisappear(_ animated: Bool) {
		AppState.shared.appState = .isNotModal
	}
}
