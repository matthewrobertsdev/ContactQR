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
		if let iCloudDataAttributedString=ContactCloudDataDescriber.getAttributedStringDescription(color: UIColor.label) {
				dataDescriptionTextField.attributedText=iCloudDataAttributedString
			}
		}
}
