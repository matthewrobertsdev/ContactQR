//
//  ChooseColorTableViewController.swift
//  Air Contacts
//
//  Created by Matt Roberts on 11/24/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import UIKit
import Contacts
class ChooseColorTableViewController: UITableViewController {
	@IBOutlet weak var nextButton: UIBarButtonItem!
	let model=ColorModel()
	var forEditing=false
	var contact=CNContact()
	var contactCard: ContactCard?
    override func viewDidLoad() {
        super.viewDidLoad()
		nextButton.isEnabled=false
		tableView.selectionFollowsFocus=true
		if forEditing {
			navigationItem.leftBarButtonItem?.title="Save"
		}
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		AppState.shared.appState=AppStateValue.isModal
		NotificationCenter.default.post(name: .modalityChanged, object: nil)
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		AppState.shared.appState=AppStateValue.isNotModal
		NotificationCenter.default.post(name: .modalityChanged, object: nil)
	}
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
		return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return model.colors.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell=tableView.dequeueReusableCell(withIdentifier:
														"SavedContactCell", for: indexPath) as? SavedContactCell else {
			return UITableViewCell()
		}
		cell.circularColorView.backgroundColor=model.colors[indexPath.row].color
		cell.nameLabel.text=model.colors[indexPath.row].name
		return cell
    }
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		nextButton.isEnabled=true
	}
	@IBAction func next(_ sender: Any) {
		guard let indexPath=tableView.indexPathForSelectedRow else {
			return
		}
		if forEditing {
			contactCard?.color=model.colors[indexPath.row].name
			ContactCardStore.sharedInstance.saveContacts()
			NotificationCenter.default.post(name: .contactUpdated, object: self, userInfo: ["uuid":self.contactCard?.uuidString ?? ""])
			navigationController?.dismiss(animated: true)
		}
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		guard let saveContactCardViewController=storyboard.instantiateViewController(withIdentifier:
																						"SaveContactCardViewController")
				as? SaveContactCardViewController else {
			print("Failed to instantiate SaveContactCardViewController")
			return
		}
		saveContactCardViewController.contact=contact
		saveContactCardViewController.color=model.colors[indexPath.row].name
		navigationController?.pushViewController(saveContactCardViewController, animated: true)
	}
	@IBAction func cancel(_ sender: Any) {
		navigationController?.dismiss(animated: true)
	}
	override var canBecomeFirstResponder: Bool {
		return true
	}
	override var keyCommands: [UIKeyCommand]? {
		return [UIKeyCommand(title: "Close", image: nil, action: #selector(cancel(_:)), input: UIKeyCommand.inputEscape,
							 modifierFlags: .command, propertyList: nil, alternates: [], discoverabilityTitle: "Close",
							 attributes: .destructive, state: .on)]
	}
	/*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle:
	UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into
				the array, and add a new row to the table view
        }    
    }
    */
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
