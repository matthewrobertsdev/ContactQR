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
				if let fileURL=ContactDataConverter.writeArchive(contactCards: contactCards, directoryURL: directoryURL, fileExtension: "ccbu") {
					let exportContactCardViewController = SaveDocumentViewController(forExporting: [fileURL], asCopy: false)
					exportContactCardViewController.url=fileURL
					present(exportContactCardViewController, animated: true)
				}
					#else
				/*
					let doumentsUrl=getDocumentsDirectory()
					ContactDataConverter.writeArchive(contactCards: contactCards, directoryURL: doumentsUrl, fileExtension: "cca")
*/
				if let fileURL=ContactDataConverter.writeArchive(contactCards: contactCards, directoryURL: directoryURL, fileExtension: "ccbu") {
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
		let loadDocumentController=LoadDocumentViewController(presentationController: self)
		loadDocumentController.presentPicker()
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
