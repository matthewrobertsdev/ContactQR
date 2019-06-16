//
//  CreateQRController.swift
//  ContactExchange
//
//  Created by Matt Roberts on 6/14/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//

import UIKit
import Contacts

class GiveQRController: NSObject, UITableViewDelegate{
    
    var vc: GiveQR_VC!
    
    var addContactController=AddContactController()
    
    let tvDataSource=StoredContactsTVDataSource()
    
    let tvDelegate=StoredContactsTVDelegate()
    
    init(createQR_VC: GiveQR_VC!) {
        super.init()
        self.vc=createQR_VC
        self.vc.storedContactsTV.delegate=tvDelegate
        self.vc.storedContactsTV.dataSource=tvDataSource
        self.vc.storedContactsTV.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(displayQRforContact), name: .contactChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(displayQRforContact), name: .contactCreated, object: addContactController)
        NotificationCenter.default.addObserver(self, selector: #selector(stopEditing), name: .allDeleted, object: addContactController)
    }
    
    
    //calls a pick conact view controller so the user can pick a contact (notiication is sent that calls respondToContactChoice if user chooses a contact
    func chooseExistingContact(){
        let pickContactVC=PickContactVC()
        vc.present(pickContactVC, animated: true)
    }
    
    func createNewContact(){
        if (PrivacyPermissions.contactPrivacyCheck(presentingVC: vc)){
            addContactController.showAddContactUI(presentingVC: vc, contactToAdd: CNContact(), forQR: true)
        }
    }
    
    //if activeContact isn't nil, piush a DisplayQR_VC
    @objc private func displayQRforContact(notification: NSNotification) {
        if (ActiveContact.shared.activeContact==nil){
            return
        }
        let displayQR_VC = vc.storyboard?.instantiateViewController(withIdentifier: "DisplayQR_VC") as! DisplayQR_VC
        vc.navigationController?.pushViewController(displayQR_VC, animated: false)
    }
    
    @objc func toggleEditing(){
        if (vc.storedContactsTV.isEditing){
            stopEditing()
        }
        else if StoredContacts.shared.contacts.count>0{
            //set it to state when it is editing
            vc.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(toggleEditing)), animated: true)
            vc.storedContactsTV.setEditing(true, animated: true)
            print("set editing")
        }
    }
    
    @objc func stopEditing(){
        //set it back to state when it is not editing
        vc.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(toggleEditing)), animated: true)
        
        vc.storedContactsTV.setEditing(false, animated: true)
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
