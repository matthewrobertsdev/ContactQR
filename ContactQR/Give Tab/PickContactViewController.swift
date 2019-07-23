//
//  PickContactDelegate.swift
//  CardQR
//
//  Created by Matt Roberts on 12/18/18.
//  Copyright © 2018 Matt Roberts. All rights reserved.
//
import ContactsUI
/*
 A CNContactPickerViewController subclassed to be a delgate that
 assigns a chosen contact to ActiveContact.shared.activeContact
 */
class PickContactVC: CNContactPickerViewController, CNContactPickerDelegate {
    //set as CNContactPickerDelegate
    override func viewDidLoad() {
        delegate=self
    }
    /*
    delegate function.  Assigns to ActiveContact shared singleton object
    and posts notification so observing classes can get notificiation
     */
    func contactPicker(_ picker: CNContactPickerViewController,
                       didSelect contact: CNContact) {
        ActiveContact.shared.contact=contact
        NotificationCenter.default.post(name: .contactChanged, object: self)
    }
}
