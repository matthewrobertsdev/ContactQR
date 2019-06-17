//
//  StoredContactsTVDelegate.swift
//  ContactExchange
//
//  Created by Matt Roberts on 6/16/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//

import UIKit

 class StoredContactsTVDelegate: NSObject, UITableViewDelegate {
    
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
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath){
        do{
            ActiveContact.shared.activeContact=try ContactDataConverter.createCNContactArray(vCardString: StoredContacts.shared.contacts[indexPath.row].vCardString).first
        }
        catch{
            print(error)
        }
        NotificationCenter.default.post(name: .contactChanged, object: self)
    }
}

extension Notification.Name{
    
    static let allDeleted=Notification.Name("all-deleted")
}
