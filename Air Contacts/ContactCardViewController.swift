//
//  ContactCardViewController.swift
//  Air Contacts
//
//  Created by Matt Roberts on 11/13/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import UIKit
class ContactCardViewController: UIViewController {
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var contactInfoLabel: UILabel!
	var contactCard: ContactCard?
	private var contactDisplayStrings=[String]()
    override func viewDidLoad() {
        super.viewDidLoad()
		let shareBarButtonItem=UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"),
											   style: .plain, target: self, action: nil)
		let qrCodeBarButtonItem=UIBarButtonItem(image: UIImage(systemName: "qrcode"), style: .plain,
												target: self, action: nil)
		navigationItem.rightBarButtonItems=[shareBarButtonItem, qrCodeBarButtonItem]
		navigationItem.title="Contact Card"
		//tableView.dataSource=self
		loadContact()
		let notificationCenter=NotificationCenter.default
		notificationCenter.addObserver(self, selector: #selector(loadContact), name: .contactChanged, object: nil)
    }
	func showOrHideTableView() {
		if contactCard==nil {
			scrollView.isHidden=true
		} else {
			scrollView.isHidden=false
		}
	}
	@objc func loadContact() {
		guard let contactCard=ActiveContactCard.shared.contactCard else {
			scrollView.isHidden=true
			return
		}
		scrollView.isHidden=false
		titleLabel.text=contactCard.filename
		do {
			let contact=try ContactDataConverter.createCNContactArray(vCardString: contactCard.vCardString)[0]
			//let contactInfoArray=ContactInfoManipulator.makeContactInfoArray(cnContact: contact)
			//contactDisplayStrings=ContactInfoManipulator.makeContactDisplayArray(contactInfo: contactInfoArray)
			contactInfoLabel.text=ContactInfoManipulator.makeContactDisplayString(cnContact: contact)
			//tableView.reloadData()
		} catch {
			print("Error making CNContact from VCard String.")
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
	/*
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return contactDisplayStrings.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell=tableView.dequeueReusableCell(withIdentifier: "ContactInfoTableViewCell") as? ContactInfoTableViewCell else {
			return UITableViewCell()
		}
		cell.infoLabel.text=contactDisplayStrings[indexPath.row]
		return cell
	}
*/
}
