//
//  CreateQRController.swift
//  ContactExchange
//
//  Created by Matt Roberts on 6/14/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//

import UIKit
import Contacts

class CreateQRController{
    
    var vc: CreateQR_VC!
    
    var addContactController=AddContactController()
    
    init(createQR_VC: CreateQR_VC!) {
        self.vc=createQR_VC
        
        NotificationCenter.default.addObserver(self, selector: #selector(displayQRforContact), name: .contactChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(displayQRforContact), name: .contactCreated, object: addContactController)
    }
    
    //calls a pick conact view controller so the user can pick a contact (notiication is sent that calls respondToContactChoice if user chooses a contact
    func chooseExistingContact(){
        let pickContactVC=PickContactVC()
        vc.present(pickContactVC, animated: true)
    }
    
    func createNewContact(){
        if (Privacy.contactPrivacyCheck(presentingVC: vc)){
            addContactController.showAddContactUI(presentingVC: vc, contactToAdd: CNContact(), forQR: true)
        }
    }
    
    //if activeContact isn't nil, assigbn it to model, make and assign the qr code, update the table view's data source, and reload the table view
    @objc private func displayQRforContact(notification: NSNotification) {
        if (ActiveContact.shared.activeContact==nil){
            return
        }
        let displayQR_VC = vc.storyboard?.instantiateViewController(withIdentifier: "DisplayQR_VC") as! DisplayQR_VC
        vc.navigationController?.pushViewController(displayQR_VC, animated: false)
    }
    
    
}
