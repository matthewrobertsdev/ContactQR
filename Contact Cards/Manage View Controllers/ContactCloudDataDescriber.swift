//
//  ContactCloudDataDescriber.swift
//  Contact Cards
//
//  Created by Matt Roberts on 5/26/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class ContactCloudDataDescriber {
	static func getAttributedStringDescription(color: UIColor) -> NSAttributedString? {
		let iCloudDataAttributedString=NSMutableAttributedString()
		iCloudDataAttributedString.append(NSAttributedString(string: "If you have sync with "))
		iCloudDataAttributedString.append(NSAttributedString(string: "iCloud on for this app and have given it adequate time for it to sync over the "))
		iCloudDataAttributedString.append(NSAttributedString(string: "internet, this description should accurately represent your data in iCloud for the "))
		iCloudDataAttributedString.append(NSAttributedString(string: "Contact Cards app.\n\n\n"))
		let headerLength=iCloudDataAttributedString.length
		iCloudDataAttributedString.append(NSAttributedString(string: "[\n"))
		guard let persistentContainer=(UIApplication.shared.delegate as? AppDelegate)?.persistentContainer else {
			return nil
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
						if let qrCodeImage = UIImage(data: qrCodeData, scale: 1) {
							if let smallQrCodeImage=resized(image: qrCodeImage, toWidth: 300) {
							let imageAttachment = NSTextAttachment()
							imageAttachment.bounds = CGRect(x: 0, y: -280, width: 300, height: 300)
							imageAttachment.image = smallQrCodeImage
							iCloudDataAttributedString.append(NSAttributedString(string: "qrCodeImage: "))
							iCloudDataAttributedString.append(NSAttributedString(attachment: imageAttachment))
							iCloudDataAttributedString.append(NSAttributedString(string: "\n"))
							}
						}
					}
					iCloudDataAttributedString.append(NSAttributedString(string: "}\n"))
				}
			}
		} catch {
			print("Error fetching data for iCloud data description")
			return nil
		}
		iCloudDataAttributedString.append(NSAttributedString(string: "]\n"))
		let headerParagraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
		headerParagraphStyle.alignment = NSTextAlignment.center
		let headerAttributes = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: CGFloat(18), weight: UIFont.Weight.light),
								 NSAttributedString.Key.paragraphStyle: headerParagraphStyle, .foregroundColor: UIColor.systemBlue]
		let bodyParagraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
		bodyParagraphStyle.alignment = NSTextAlignment.left
		let bodyAttributes = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: CGFloat(18), weight: UIFont.Weight.light),
							   NSAttributedString.Key.paragraphStyle: bodyParagraphStyle, .foregroundColor: color]
		iCloudDataAttributedString.addAttributes(headerAttributes, range: NSRange(location: 0, length: headerLength))
		iCloudDataAttributedString.addAttributes(bodyAttributes, range: NSRange(location: headerLength-1, length: iCloudDataAttributedString.length-headerLength))
		return iCloudDataAttributedString
	}
	static func resized(image: UIImage, toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
		let canvas = CGSize(width: width, height: CGFloat(ceil(width/image.size.width * image.size.height)))
		let format = image.imageRendererFormat
  format.opaque = isOpaque
  return UIGraphicsImageRenderer(size: canvas, format: format).image {
	_ in image.draw(in: CGRect(origin: .zero, size: canvas))
  }
}
}
