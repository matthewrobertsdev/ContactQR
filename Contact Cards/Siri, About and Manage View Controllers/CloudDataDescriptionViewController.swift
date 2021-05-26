//
//  iCloudDataDescriptionViewController.swift
//  Contact Cards
//
//  Created by Matt Roberts on 5/25/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import UIKit
import CoreData
class CloudDataDescriptionViewController: UIViewController {
	@IBOutlet weak var dataDescriptionTextField: UITextView!
	override func viewDidLoad() {
        super.viewDidLoad()
		let iCloudDataAttributedString=NSMutableAttributedString()
		iCloudDataAttributedString.append(NSAttributedString(string: "[\n"))
		guard let persistentContainer=(UIApplication.shared.delegate as? AppDelegate)?.persistentContainer else {
			return
		}
		let managedObjectContext=persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<ContactCardMO>(entityName: ContactCardMO.entityName)
			do {
				// Execute Fetch Request
				let contactCardMOs = try managedObjectContext.fetch(fetchRequest)
				for index in 0..<contactCardMOs.count {
					if let contactCardMO = try persistentContainer.viewContext.existingObject(with: contactCardMOs[index].objectID) as? ContactCardMO {
			iCloudDataAttributedString.append(NSAttributedString(string: "{\n"))
						iCloudDataAttributedString.append(NSAttributedString(string: "filename: \(contactCardMO.filename)\n"))
						iCloudDataAttributedString.append(NSAttributedString(string: "color: \(contactCardMO.color)\n"))
						iCloudDataAttributedString.append(NSAttributedString(string: "vCardString: \(contactCardMO.vCardString)\n"))
						if let qrCodeData = contactCardMO.qrCodeImage {
							if let qrCodeImage = UIImage(data: qrCodeData) {
					let imageAttachment = NSTextAttachment()
					imageAttachment.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
					imageAttachment.image = qrCodeImage
					iCloudDataAttributedString.append(NSAttributedString(string: "qrCodeImage: "))
					iCloudDataAttributedString.append(NSAttributedString(attachment: imageAttachment))
								iCloudDataAttributedString.append(NSAttributedString(string: "\n"))
							}
						}
					iCloudDataAttributedString.append(NSAttributedString(string: "}\n"))
				}
				}
			} catch {
				print("Error fetching data for iCloud data description")
			}
			iCloudDataAttributedString.append(NSAttributedString(string: "]\n"))
		let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = NSTextAlignment.left
		let color=UIColor.label
		let fontAttributes = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: CGFloat(18), weight: UIFont.Weight.light),
							   NSAttributedString.Key.paragraphStyle: paragraphStyle, .foregroundColor: color]

		iCloudDataAttributedString.addAttributes(fontAttributes, range: NSRange(location: 0, length: iCloudDataAttributedString.length))
			dataDescriptionTextField.attributedText=iCloudDataAttributedString
		}
	@IBAction func done(_ sender: Any) {
		dismiss(animated: true)
	}
        // Do any additional setup after loading the view.
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
