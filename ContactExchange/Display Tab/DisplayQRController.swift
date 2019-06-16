//
//  DisplayQRController.swift
//  CardQR
//
//  Created by Matt Roberts on 12/14/18.
//  Copyright © 2018 Matt Roberts. All rights reserved.
//

import ContactsUI

/*
 Gets contact, gets conversion of it from model, and updates qr code image view and the tableview
 */
class DisplayQRController{
    
     //model for managing data concerning the CNContact, its properties, and the qr code
    private let model=DisplayQRModel()
    
    //doesn't do anything now
    private let contactTVDelegate=ContactTVDelegate()
    
    //the display qr code view controller
    private let vc: DisplayQR_VC
    
    //assign view controller, set-up table view, and add observer to .contactChanged notification
    init(displayQR_VC: DisplayQR_VC){
        vc=displayQR_VC
       
        print(model.description)
        print(model.getContactTVDataSource().description)
        print(vc.contactInfoTV.description)
        vc.contactInfoTV.dataSource=model.getContactTVDataSource()
        vc.contactInfoTV.delegate=contactTVDelegate
        
        //NotificationCenter.default.addObserver(self, selector: #selector(respondToContactChoice), name: .contactChanged, object: nil)
    }
    
    //if activeContact isn't nil, assigbn it to model, make and assign the qr code, update the table view's data source, and reload the table view
    func prepareView() {
        if (ActiveContact.shared.activeContact==nil){
            return
        }
        model.updateActiveContact(activeContact: ActiveContact.shared.activeContact!)
        vc.qrImageView.image=model.makeQRCode()
        model.updateContactInfoTVDataSource()
        vc.contactInfoTV.reloadData()
    }
    
    @objc func presentSaveDialog(){
        //StoredContacts.shared.contacts.append()
        let manageSaveAlert=UIAlertController(title: "Save Contact", message: "Please enter the name for this QR code", preferredStyle: UIAlertController.Style.alert)
        manageSaveAlert.addTextField()
        manageSaveAlert.addAction(UIAlertAction(title: "Cancel", style: .default))
        manageSaveAlert.addAction(UIAlertAction(title: NSLocalizedString("Save", comment: "Alert button to save contyact with title"), style: .default, handler: { _  in self.addToStoredContacts(name: manageSaveAlert.textFields![0].text!)}))
        DispatchQueue.main.async {
            self.vc.present(manageSaveAlert, animated: true)
        }
    }
    
    func addToStoredContacts(name: String){
        print("Adding to contact store "+name)
        let contactToStore=SavedContact(name: name, cnContact: ActiveContact.shared.activeContact!)
        StoredContacts.shared.contacts.append(contactToStore)
        StoredContacts.shared.tryToSave()
        //StoredContacts.shared.testEncodeAndDecode()
        NotificationCenter.default.post(name: .contactAdded, object: self)
    }
    
    //calls a pick conact view controller so the user can pick a contact (notiication is sent that calls respondToContactChoice if user chooses a contact
    
    
}
