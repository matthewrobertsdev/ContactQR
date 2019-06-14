//
//  AddContact.swift
//  ContactExchange
//
//  Created by Matt Roberts on 6/14/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//

import ContactsUI

class AddContactController: NSObject,CNContactViewControllerDelegate{
    
    var addContactNC: UINavigationController!
    
    var forQR: Bool!
    
    func showAddContactUI(presentingVC: UIViewController, contactToAdd: CNContact, forQR: Bool){
        self.forQR=forQR
        let addContactVC=CNContactViewController(forNewContact: contactToAdd)
        addContactVC.delegate=self
        addContactNC=UINavigationController(rootViewController: addContactVC)
        presentingVC.present(addContactNC, animated: true)
    }
    
    func contactViewController(_ viewController: CNContactViewController,
                               didCompleteWith contact: CNContact?){
        if (forQR){
            ActiveContact.shared.activeContact=contact
        }
        viewController.dismiss(animated: !forQR)
        NotificationCenter.default.post(name: .contactCreated, object: self)
    }
    
}

/*
 Post this when contact is created
 */
extension Notification.Name{
    
    //Reference as .contactChanged when type inference is possible
    static let contactCreated=Notification.Name("contact-created")
}
