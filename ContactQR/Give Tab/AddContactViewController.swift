//
//  AddContact.swift
//  ContactExchange
//
//  Created by Matt Roberts on 6/14/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//
import ContactsUI
class AddContactViewController: NSObject, CNContactViewControllerDelegate {
    var addContactNC: UINavigationController!
    var forQR: Bool!
    func showUI(viewController: UIViewController, contact: CNContact, forQR: Bool) {
        self.forQR=forQR
        let addContactVC=CNContactViewController(forNewContact: contact)
        addContactVC.delegate=self
        addContactNC=UINavigationController(rootViewController: addContactVC)
        viewController.present(addContactNC, animated: true)
    }
    func contactViewController(_ viewController: CNContactViewController,
                               didCompleteWith contact: CNContact?) {
        if forQR {
            ActiveContact.shared.contact=contact
        }
        viewController.dismiss(animated: true)
        NotificationCenter.default.post(name: .contactCreated, object: self)
    }
	
	
}
/*
 Post this when contact is created
 */
extension Notification.Name {
    //Reference as .contactChanged when type inference is possible
    static let contactCreated=Notification.Name("contact-created")
}
