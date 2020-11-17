//
//  ContactCardTableViewController.swift
//  Air Contacts
//
//  Created by Matt Roberts on 11/12/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import UIKit
class ContactCardsTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
		let notificationCenter=NotificationCenter.default
		notificationCenter.addObserver(self, selector: #selector(selectNewContact), name: .contactCreated, object: nil)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		guard let selectedIndexPath=tableView.indexPathForSelectedRow else {
			return
		}
		guard let splitViewController=splitViewController else {
			return
		}
		if splitViewController.isCollapsed {
			tableView.deselectRow(at: selectedIndexPath, animated: false)
		}
	}
	@objc func selectNewContact() {
		tableView.reloadData()
		let lastRowNumber=ContactCardStore.sharedInstance.contacts.count-1
		tableView.selectRow(at: IndexPath(row: lastRowNumber, section: 0), animated: true, scrollPosition: .middle)
		showContactCard()
	}
	func showContactCard() {
		guard let splitViewController=splitViewController else {
			return
		}
		//bug: should be only 14 and above according to plist
		if #available(iOS 14.0, *) {
			splitViewController.show(.secondary)
		} else {
		}
	}
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ContactCardStore.sharedInstance.contacts.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        // Configure the cell...
        return cell
    }
	@IBAction func createContactCardFromContact(_ sender: Any) {
		self.present(PickContactViewController(), animated: true) {
		}
	}
	override func tableView(_ tableView: UITableView,
							didSelectRowAt indexPath: IndexPath) {
		showContactCard()
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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
