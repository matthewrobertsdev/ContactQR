//
//  StoredContactsTVDelegate.swift
//  ContactExchange
//
//  Created by Matt Roberts on 6/16/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//

import UIKit

 class StoredContactsTVDelegate: NSObject, UITableViewDelegate {
    /*
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print("should delete")
        StoredContacts.shared.contacts.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        
        
        return true
    }
 */
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            StoredContacts.shared.contacts.remove(at: indexPath.row)
            StoredContacts.shared.tryToSave()
            tableView.deleteRows(at: [indexPath], with: .fade)
            if (StoredContacts.shared.contacts.count==0){
                NotificationCenter.default.post(Notification(name: .allDeleted))
            }
        }
        
        
        return [delete]
    }
}

extension Notification.Name{
    
    static let allDeleted=Notification.Name("all-deleted")
}
