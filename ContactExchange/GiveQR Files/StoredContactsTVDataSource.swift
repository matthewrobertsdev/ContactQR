//
//  StoredContactsTVDataSource.swift
//  ContactExchange
//
//  Created by Matt Roberts on 6/14/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//

import UIKit

class StoredContactsTVDataSource: NSObject, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("total contacts loaded by TV"+StoredContacts.shared.contacts.count.description)
        return StoredContacts.shared.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let savedContactTVCell=tableView.dequeueReusableCell(withIdentifier: "SavedContactTVCell") as! SavedContactTVCell
        
        savedContactTVCell.nameLabel.text=StoredContacts.shared.contacts[indexPath.row].name
        return savedContactTVCell
    }
    




}
