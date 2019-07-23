//
//  StoredContactsTVDataSource.swift
//  ContactExchange
//
//  Created by Matt Roberts on 6/14/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//

import UIKit

/*
 A data source for the give contact table view entirely based off of
 StoredContacts.shared
 */
extension GiveQRController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        return "My Contact Info"
    }
    //num in table is num in StoredContacts.shared
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("total contacts loaded by TV"+StoredContacts.shared.contacts.count.description)
        return StoredContacts.shared.contacts.count
    }
    //a cell is just a SavedContactTVCell with the filename of a contact as its
    //label's text
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let contactCell=tableView.dequeueReusableCell(withIdentifier: "SavedContactCell") as? SavedContactCell else {
            return UITableViewCell()
        }
        contactCell.nameLabel.text=StoredContacts.shared.contacts[indexPath.row].filename
        return contactCell
    }

}
