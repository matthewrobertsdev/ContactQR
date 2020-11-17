//
//  SaveContactCardViewController.swift
//  Air Contacts
//
//  Created by Matt Roberts on 11/15/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import UIKit
import Contacts
class SaveContactCardViewController: UIViewController {
	var contact=CNContact()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
	@IBAction func save(_ sender: Any) {
		ContactCardStore.sharedInstance.contacts.append(contact)
		dismiss(animated: true) {
			NotificationCenter.default.post(name: .contactCreated, object: self, userInfo: nil)
		}
	}
	@IBAction func cancel(_ sender: Any) {
		dismiss(animated: true)
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
