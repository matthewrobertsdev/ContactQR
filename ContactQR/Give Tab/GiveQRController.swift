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
    var viewController: GiveQRViewController!
    var pickContactVC=PickContactVC()
    var addContactController=AddContactController()
    let tvDataSource=StoredContactsTVDataSource()
    init(createQRViewController: GiveQRViewController!) {
        super.init()
        self.viewController=createQRViewController
        self.viewController.storedContactsTV.delegate=StoredContactsTVDelegate()
        self.viewController.storedContactsTV.dataSource=tvDataSource
        self.viewController.storedContactsTV.reloadData()
        //Need to post from different places and have different responses
        NotificationCenter.default.addObserver(self, selector: #selector(displayQRforContact), name: .contactChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(displayQRforContact), name: .contactCreated, object: addContactController)
        NotificationCenter.default.addObserver(self, selector: #selector(stopEditing), name: .allDeleted, object: addContactController)
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
        if (PrivacyPermissions.contactPrivacyCheck(presentingVC: viewController)){
            addContactController.showAddContactUI(presentingVC: viewController, contactToAdd: CNContact(), forQR: true)
        }
    }
    //if activeContact isn't nil, piush a DisplayQR_VC
    @objc private func displayQRforContact(notification: NSNotification) {
        if (ActiveContact.shared.activeContact==nil) {
            return
        }
        var animated=false
        guard let displayQRViewController = viewController.storyboard?.instantiateViewController(withIdentifier: "DisplayQR_VC") as? DisplayQRViewController else{
            return
        }
        if notification.object is StoredContactsTVDelegate {
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
            print("set editing")
        }
    }
    @objc func stopEditing() {
        //set it back to state when it is not editing
       let editBarButton=UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(toggleEditing))
        viewController.navigationItem.setRightBarButton(editBarButton, animated: true)
        viewController.storedContactsTV.setEditing(false, animated: true)
        print("set normal")
    }
    /*
     Table view
        delete
        rename rows
        move rows
        model
        save to disk
     active contact
        save to disk
     */
}
