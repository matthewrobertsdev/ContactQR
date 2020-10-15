//
//  CreateQRController.swift
//  ContactExchange
//
//  Created by Matt Roberts on 6/14/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//

import UIKit
import Contacts

class GiveQRController: NSObject, UITableViewDelegate {
    //properties
    var viewController: GiveQRViewController!
    var pickContactVC=PickContactVC()
    var addContactViewController=AddContactViewController()
    let notificationCenter=NotificationCenter.default
    //init
    init(createQRViewController: GiveQRViewController!) {
        super.init()
        self.viewController=createQRViewController
        self.viewController.storedContactsTV.delegate=self
        self.viewController.storedContactsTV.dataSource=self
        self.viewController.storedContactsTV.reloadData()
		//CameraPrivacy.check(viewController: createQRViewController, appName: Constants.APPNAME)
        //Need to post from different places and have different responses
        notificationCenter.addObserver(self, selector: #selector(displayQR), name: .contactChanged, object: nil)
        notificationCenter.addObserver(self, selector: #selector(displayQR), name: .contactCreated, object: nil)
        notificationCenter.addObserver(self, selector: #selector(stopEditing), name: .allDeleted, object: nil)
    }
    /*
     calls a pick conact view controller so the user can pick a contact
     (notiication is sent that calls respondToContactChoice if user chooses a
     contact
     */
    func chooseExistingContact() {
        pickContactVC=PickContactVC()
        viewController.present(pickContactVC, animated: true)
    }
    func createNewContact() {
		/*
        if ContactsPrivacy.check(viewController: viewController, appName: Constants.APPNAME) {
            addContactViewController.showUI(viewController: viewController, contact: CNContact(), forQR: true)
        }
*/
    }
    //if activeContact isn't nil, piush a DisplayQR_VC
    @objc private func displayQR(notification: NSNotification) {
        if ActiveContact.shared.contact==nil {
            return
        }
		var animated=false
		if let animatedUserInfo=notification.userInfo?["animated"] as? Bool {
			animated=animatedUserInfo
		}
        let storyBoard=viewController.storyboard
        let desiredViewController = storyBoard?.instantiateViewController(withIdentifier: "DisplayQRViewController")
        guard let displayQRViewController = desiredViewController as? DisplayQRViewController else {
            return
        }
        if notification.object is GiveQRController {
            animated=true
            displayQRViewController.savable=false
        }
        viewController.navigationController?.pushViewController(displayQRViewController, animated: animated)
    }
    @objc func toggleEditing() {
        if viewController.storedContactsTV.isEditing {
            stopEditing()
        } else if StoredContacts.shared.contacts.count>0 {
            //set it to state when it is editing
           let editBarButton=UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(toggleEditing))
            viewController.navigationItem.setRightBarButton(editBarButton, animated: true)
            viewController.storedContactsTV.setEditing(true, animated: true)
        }
    }
    @objc func stopEditing() {
        //set it back to state when it is not editing
       let editBarButton=UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(toggleEditing))
        viewController.navigationItem.setRightBarButton(editBarButton, animated: true)
        viewController.storedContactsTV.setEditing(false, animated: true)
    }
	/*
    //delete from the model, save, and delete from the tableview
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
            StoredContacts.shared.contacts.remove(at: indexPath.row)
            StoredContacts.shared.tryToSave()
            tableView.deleteRows(at: [indexPath], with: .fade)
            //so that the save button can be disabled
            if StoredContacts.shared.contacts.count==0 {
                NotificationCenter.default.post(Notification(name: .allDeleted))
            }
        }
        return [delete]
    }
*/
	
	func tableView(_ tableView: UITableView,
			  leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		return UISwipeActionsConfiguration(actions:[UIContextualAction(style: UIContextualAction.Style.destructive, title: "Delete", handler: { (action, view, copmpletionHandler) in
			StoredContacts.shared.contacts.remove(at: indexPath.row)
            StoredContacts.shared.tryToSave()
            tableView.deleteRows(at: [indexPath], with: .fade)
            //so that the save button can be disabled
            if StoredContacts.shared.contacts.count==0 {
                NotificationCenter.default.post(Notification(name: .allDeleted))
            }
		})])
	}
    /*
     save selected contact to ActiveContact and post notification that contactChanged,
     so that the display VC can be presented
     */
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        do {
            guard let contactVCard=StoredContacts.shared.contacts[indexPath.row].vCardString else {
                return
            }
            ActiveContact.shared.contact=try ContactDataConverter.createCNContactArray(vCardString: contactVCard).first
        } catch {
            print(error)
        }
        NotificationCenter.default.post(name: .contactChanged, object: self)
    }
}
//name for notification for when all saved contacts have been deleted
extension Notification.Name {
    static let allDeleted=Notification.Name("all-deleted")
}
