//
//  StoredContactsTVDelegate.swift
//  ContactExchange
//
//  Created by Matt Roberts on 6/16/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//

import UIKit

//for the delegate for the tableview for contacts you have saved for quick access
 class StoredContactsTVDelegate: NSObject, UITableViewDelegate {
    
    //delete from the model, save, and delete from the tableview
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            StoredContacts.shared.contacts.remove(at: indexPath.row)
            StoredContacts.shared.tryToSave()
            tableView.deleteRows(at: [indexPath], with: .fade)
            //so that the save button can be disabled
            if (StoredContacts.shared.contacts.count==0){
                NotificationCenter.default.post(Notification(name: .allDeleted))
            }
        }
        
        return [delete]
    }
    
    /*
     save selected contact to ActiveContact and post notification that contactChanged,
     so that the display VC can be presented
     */
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

//name for notification for when all saved contacts have been deleted
extension Notification.Name{
    
    static let allDeleted=Notification.Name("all-deleted")
}
