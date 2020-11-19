//
//  ContactCardViewController.swift
//  Air Contacts
//
//  Created by Matt Roberts on 11/13/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import UIKit
class ContactCardViewController: UIViewController, UITableViewDataSource {
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var titleLabel: UILabel!
	var contactCard: ContactCard?
	private var contactInfoArray: [(String, String)]=[]
    override func viewDidLoad() {
        super.viewDidLoad()
		let shareBarButtonItem=UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"),
											   style: .plain, target: self, action: nil)
		let qrCodeBarButtonItem=UIBarButtonItem(image: UIImage(systemName: "qrcode"), style: .plain,
												target: self, action: nil)
		navigationItem.rightBarButtonItems=[shareBarButtonItem, qrCodeBarButtonItem]
		navigationItem.title="Contact Card"
		tableView.dataSource=self
		loadContact()
		let notificationCenter=NotificationCenter.default
		notificationCenter.addObserver(self, selector: #selector(loadContact), name: .contactChanged, object: nil)
    }
	func showOrHideTableView() {
		if contactCard==nil {
			tableView.isHidden=true
		} else {
			tableView.isHidden=false
		}
	}
	@objc func loadContact() {
		guard let contactCard=ActiveContactCard.shared.contactCard else {
			tableView.isHidden=true
			return
		}
		tableView.isHidden=false
		titleLabel.text=contactCard.filename
		do {
			let contact=try ContactDataConverter.createCNContactArray(vCardString: contactCard.vCardString)[0]
			contactInfoArray=ContactInfoManipulator.makeContactInfoArray(cnContact: contact)
			tableView.reloadData()
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
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return contactInfoArray.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell=tableView.dequeueReusableCell(withIdentifier: "ContactInfoTableViewCell") as? ContactInfoTableViewCell else {
			return UITableViewCell()
		}
		cell.labelLabel.text=contactInfoArray[indexPath.row].0
		cell.infoLabel.text=contactInfoArray[indexPath.row].1
		return cell
	}
}
