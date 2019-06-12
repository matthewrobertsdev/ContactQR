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
        vc.contactInfoTV.dataSource=model.getContactTVDataSource()
        vc.contactInfoTV.delegate=contactTVDelegate
        NotificationCenter.default.addObserver(self, selector: #selector(respondToContactChoice), name: .contactChanged, object: nil)
    }
    
    //if activeContact isn't nil, assigbn it to model, make and assign the qr code, update the table view's data source, and reload the table view
    @objc private func respondToContactChoice(notification: NSNotification) {
        if (ActiveContact.shared.activeContact==nil){
            return
        }
        /*
        model.makeVCardString()
        print(model.getVCardString())
        model.makeQRCode()
         */
        model.updateActiveContact(activeContact: ActiveContact.shared.activeContact!)
        vc.qrImageView.image=model.makeQRCode()
        model.updateContactInfoTVDataSource()
        vc.contactInfoTV.reloadData()
    }
    
    //calls a pick conact view controller so the user can pick a contact (notiication is sent that calls respondToContactChoice if user chooses a contact
    func chooseContact(vc: UIViewController){
        let pickContactVC=PickContactVC()
        vc.present(pickContactVC, animated: true)
    }
    
}
