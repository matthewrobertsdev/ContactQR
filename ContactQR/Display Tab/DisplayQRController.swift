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
class DisplayQRController: NSObject, UITableViewDelegate {
     //model for managing data concerning the CNContact, its properties, and the qr code
    private let model=DisplayQRModel()
    //the display qr code view controller
    private let viewController: DisplayQRViewController
    //assign view controller, set-up table view, and add observer to .contactChanged notification
    init(displayQRViewController: DisplayQRViewController) {
        viewController=displayQRViewController
        super.init()
        viewController.contactInfoTV.dataSource=model.getContactTVDataSource()
        viewController.contactInfoTV.delegate=self
    }
    /*
     if activeContact isn't nil, assigbn it to model, make and assign the qr
     code, update the table view's data source, and reload the table view
     */
    func prepareView() {
        guard let activeContact=ActiveContact.shared.contact else {
            return
        }
        model.updateActiveContact(activeContact: activeContact)
        viewController.qrImageView.image=model.makeQRCode()
        model.updateContactInfoTVDataSource()
        viewController.contactInfoTV.reloadData()
    }
    @objc func presentSaveDialog() {
        //StoredContacts.shared.contacts.append()
        let saveMessage="Please enter the name for this QR code"
        let manageSaveAlert=UIAlertController(title: "Save Contact", message: saveMessage, preferredStyle: .alert)
        manageSaveAlert.addTextField()
        manageSaveAlert.addAction(UIAlertAction(title: "Cancel", style: .default))
        let saveAlertHandler = { (alertAction: UIAlertAction) -> Void in
            self.addToStoredContacts(name: manageSaveAlert.textFields![0].text!)
            self.viewController.disableSave()
			self.viewController.navigationController?.popToRootViewController(animated: true)
        }
        let saveAlertString=NSLocalizedString("Save", comment: "Alert button to save contact with title")
        let saveAlertAction=UIAlertAction(title: saveAlertString, style: .default, handler: saveAlertHandler)
        manageSaveAlert.addAction(saveAlertAction)
        DispatchQueue.main.async {
            self.viewController.present(manageSaveAlert, animated: true)
        }
    }
    func addToStoredContacts(name: String) {
        let contactToStore=SavedContact(name: name, cnContact: ActiveContact.shared.contact!)
        StoredContacts.shared.contacts.append(contactToStore)
        StoredContacts.shared.tryToSave()
        //StoredContacts.shared.testEncodeAndDecode()
        NotificationCenter.default.post(name: .contactAdded, object: self)
    }
    /*
     calls a pick conact view controller so the user can pick a contact
     (notiication is sent that calls respondToContactChoice if user chooses a
     contact
     */
}
