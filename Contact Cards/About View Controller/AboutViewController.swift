//
//  AboutViewController.swift
//  Contact Cards
//
//  Created by Matt Roberts on 5/17/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import UIKit
class AboutViewController: UIViewController {
	@IBOutlet weak var versionAndBuildLabel: UILabel!
	@IBOutlet weak var copyrightLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
		guard let versionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
			return
		}
		guard let buildString = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
			return
		}
		versionAndBuildLabel.text="Version \(versionString) (\(buildString))"
        // Do any additional setup after loading the view.
    }
	@IBAction func done(_ sender: Any) {
		self.dismiss(animated: true)
	}
	@IBAction func openFAQ(_ sender: Any) {
		if let appDelegate=UIApplication.shared.delegate as? AppDelegate {
			appDelegate.openFAQ()
		}
	}
	@IBAction func openHomepage(_ sender: Any) {
		if let appDelegate=UIApplication.shared.delegate as? AppDelegate {
			appDelegate.openHomepage()
		}
	}
	@IBAction func openContact(_ sender: Any) {
		if let appDelegate=UIApplication.shared.delegate as? AppDelegate {
			appDelegate.openContactTheDeveloper()
		}
	}
	@IBAction func openPrivacyPolicy(_ sender: Any) {
		if let appDelegate=UIApplication.shared.delegate as? AppDelegate {
			appDelegate.openPrivacyPolicy()
		}
	}
}
