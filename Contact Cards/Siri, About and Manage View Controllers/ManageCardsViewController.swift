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
	let managedObjectContext=(UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
	var loadDocumentController: LoadDocumentController?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
				/*
					let doumentsUrl=getDocumentsDirectory()
					ContactDataConverter.writeArchive(contactCards: contactCards, directoryURL: doumentsUrl, fileExtension: "cca")
*/
				if let fileURL=ContactDataConverter.writeArchive(contactCards: contactCards, directoryURL: directoryURL, fileExtension: "txt") {
					let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
					present(activityViewController, animated: true, completion: nil)
				}
					#endif
			} catch {
				print("Unable to save contact cards")
				//errorString=error.localizedDescription
			}
	}
	@IBAction func loadContactCardsArchive(_ sender: Any) {
		loadDocumentController=LoadDocumentController(presentationController: self, forOpeningContentTypes: [UTType.text])
		loadDocumentController?.loadHandler = {(url: URL) -> Void in
				if let contactCards=ContactDataConverter.readArchive(url: url) {
					for card in contactCards {
						guard let context=self.managedObjectContext else {
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
							try self.managedObjectContext?.save()
							self.managedObjectContext?.rollback()
							let successAlertViewController=UIAlertController(title: "Contact Cards Loaded", message: "All contact cards were successfully loaded.", preferredStyle: .alert)
							let gotItAction=UIAlertAction(title: "Got it.", style: .default, handler: { _ in
								successAlertViewController.dismiss(animated: true)
							})
							successAlertViewController.addAction(gotItAction)
							successAlertViewController.preferredAction=gotItAction
							self.present(successAlertViewController, animated: true)
						} catch {
							print(error.localizedDescription)
						}
					}
				}
				return
			}
			loadDocumentController?.presentPicker()
	}
	@IBAction func viewCardsAsRichText(_ sender: Any) {
		let iCloudDataAttributedString=NSMutableAttributedString()
		iCloudDataAttributedString.append(NSAttributedString(string: "[\n"))
		let predicate = NSPredicate(value: true)
			let sort = NSSortDescriptor(key: "filename", ascending: false)
			let query = CKQuery(recordType: "ContactCard", predicate: predicate)
			query.sortDescriptors = [sort]

			let operation = CKQueryOperation(query: query)
		operation.recordFetchedBlock = { record in
			guard let filename=record["filename"] as? String else {
				return
			}
			guard let color=record["color"] as? String else {
				return
			}
			guard let vCardString=record["vCardString"] as? String else {
				return
			}
			guard let qrCodeImageData=record["qrCodeImage"] as? Data else {
				return
			}
			guard let qrCodeImage=UIImage(data: qrCodeImageData) else {
				return
			}
			let imageAttachment = NSTextAttachment()
			imageAttachment.image = qrCodeImage
			iCloudDataAttributedString.append(NSAttributedString(string: "{\n"))
			iCloudDataAttributedString.append(NSAttributedString(string: "filename: \(filename)\n"))
			iCloudDataAttributedString.append(NSAttributedString(string: "color: \(color)\n"))
			iCloudDataAttributedString.append(NSAttributedString(string: "vCardString: \(vCardString)\n"))
			iCloudDataAttributedString.append(NSAttributedString(string: "qrCodeImage: "))
			iCloudDataAttributedString.append(NSAttributedString(attachment: imageAttachment))
			iCloudDataAttributedString.append(NSAttributedString(string: "\n"))
			iCloudDataAttributedString.append(NSAttributedString(string: "}\n"))
		}
		operation.queryCompletionBlock = { [weak self] (cursor, error) in
			DispatchQueue.main.async {
				if let _=error {
					
				} else {
					iCloudDataAttributedString.append(NSAttributedString(string: "]\n"))
				}
			}
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
	func getDocumentsDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return paths[0]
	}
}
