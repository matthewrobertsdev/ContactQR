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
	let managedObjectContext=(UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
	var loadDocumentController: LoadDocumentController?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		#if targetEnvironment(macCatalyst)
		syncWithCloudStackView.addArrangedSubview(syncWithCloudStackView.arrangedSubviews[0])
		#endif
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
	@IBAction func exportToRtfFile(_ sender: Any) {
		let attributedString=ContactCloudDataDescriber.getAttributedStringDescription(color: UIColor.black)
		guard var fileURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
				return
			}
		do {
			let data = try attributedString?.fileWrapper (from: NSRange (location: 0, length: attributedString?.length ?? 0), documentAttributes: [.documentType: NSAttributedString.DocumentType.rtfd])
		//let rtfData=try attributedString?.data(from: NSRange(location: 0, length: attributedString?.length ?? 0), documentAttributes: [.documentType: NSAttributedString.DocumentType.rtfd])
			fileURL.appendPathComponent("Contact Cards iCloud Data Description")
			fileURL.appendPathExtension("rtfd")
			try data?.write(to: fileURL, options: .atomic, originalContentsURL: nil)
			#if targetEnvironment(macCatalyst)
			let exportContactCardViewController = SaveDocumentViewController(forExporting: [fileURL], asCopy: false)
			exportContactCardViewController.url=fileURL
			present(exportContactCardViewController, animated: true)
			#else
			let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
			present(activityViewController, animated: true, completion: nil)
			#endif
		} catch {
			print("Error trying to write rtf file")
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
