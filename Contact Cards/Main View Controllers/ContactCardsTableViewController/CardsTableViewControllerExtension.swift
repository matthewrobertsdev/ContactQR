//
//  CardsTableViewControllerExtension.swift
//  Contact Cards
//
//  Created by Matt Roberts on 7/14/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//

import UIKit
// MARK: - Table view data source
extension ContactCardsTableViewController {
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let sections = fetchedResultsController?.sections {
			let currentSection = sections[section]
			return currentSection.numberOfObjects
		}
		return 0
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell=tableView.dequeueReusableCell(withIdentifier: "SavedContactCell", for: indexPath)
				as? SavedContactCell else {
			return UITableViewCell()
		}
		guard let contactCard = fetchedResultsController?.object(at: indexPath) else {
			return UITableViewCell()
		}
		cell.nameLabel.text=contactCard.filename
		let colorString=contactCard.color
		if let color=UIColor(named: "Dark"+colorString) {
			cell.circularColorView.backgroundColor=color
		} else {
			cell.circularColorView.backgroundColor=UIColor.label
		}
		return cell
	}
	override func tableView(_ tableView: UITableView,
							didSelectRowAt indexPath: IndexPath) {
		ActiveContactCard.shared.contactCard=fetchedResultsController?.object(at: indexPath)
		showContactCard()
	}
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		if tableView.isEditing {
			return true
		}
		return false
	}
	override func tableView(_ tableView: UITableView,
							editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		return .delete
	}
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
							forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			// Delete the row from the data source
			guard let resultsController=fetchedResultsController else {
				return
			}
			let contactCard = resultsController.object(at: indexPath)
			(UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext.delete(contactCard)
			stopEditingIfNoContactCards()
			NotificationCenter.default.post(name: .contactDeleted, object: nil)
			do {
			try (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext.save()
			} catch {
				print("Error saving deletion")
				present(localErrorSavingAlertController(), animated: true)
			}
		}
	}
}
