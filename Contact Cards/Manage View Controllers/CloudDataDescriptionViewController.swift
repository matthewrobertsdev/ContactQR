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
		// Do any additional setup after loading the view.
		let fullString=NSMutableAttributedString()
		fullString.append(NSAttributedString(string: "If you have sync with "))
		fullString.append(NSAttributedString(string: "iCloud on for this app and have given it adequate time for it to sync over the "))
		fullString.append(NSAttributedString(string: "internet, this description should accurately represent your data in iCloud for the "))
		fullString.append(NSAttributedString(string: "Contact Cards app.\n\n\n"))
		let headerParagraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
		headerParagraphStyle.alignment = NSTextAlignment.center
		let headerAttributes = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: CGFloat(18), weight: UIFont.Weight.light),
								 NSAttributedString.Key.paragraphStyle: headerParagraphStyle, .foregroundColor: UIColor.systemBlue]
		fullString.addAttributes(headerAttributes, range: NSRange(location: 0, length: fullString.length))
		if let iCloudDataAttributedString=ContactCloudDataDescriber.getAttributedStringDescription(color: UIColor.label) {
				fullString.append(iCloudDataAttributedString)
				dataDescriptionTextField.attributedText=fullString
			}
		}
}
