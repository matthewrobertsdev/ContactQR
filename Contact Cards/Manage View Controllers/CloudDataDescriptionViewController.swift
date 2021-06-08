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
	/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
