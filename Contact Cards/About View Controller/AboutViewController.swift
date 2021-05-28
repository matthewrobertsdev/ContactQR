//
//  AboutViewController.swift
//  Contact Cards
//
//  Created by Matt Roberts on 5/17/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import UIKit
class AboutViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
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
	/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
