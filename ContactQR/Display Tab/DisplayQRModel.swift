//
//  DisplayQRModel.swift
//  CardQR
//
//  Created by Matt Roberts on 12/18/18.
//  Copyright © 2018 Matt Roberts. All rights reserved.
//
import UIKit
import Contacts
/*
 Model for the display qr code view controller
 */
class DisplayQRModel: NSObject{
    //the contact to be put in a qr code and displayed
    private var activeContact: CNContact?
    //an array of pairs of strings for the data source of the table view
    private var contactInfoArray: [(String,String)]=[]
    private let contactTVDataSource=ContactTVDataSource()
    //the string from the v card
    private var vCardString: String!
    //the qr code containing the string from the v card
    private var qrCode: UIImage!
    func updateActiveContact(activeContact: CNContact){
        self.activeContact=activeContact
    }
    //get a v card string from a CNContact
    private func makeVCardString(){
        vCardString=ContactDataConverter.cnContactToVCardString(cnContact: activeContact!)
    }
    func getContactTVDataSource() -> ContactTVDataSource{
        return contactTVDataSource
    }
    //get the v card String
    func getVCardString() -> String{
        return vCardString
    }
    //get a qr code from the active contact
    func makeQRCode() -> UIImage{
        print(ContactDataConverter.cnContactToVCardString(cnContact: activeContact!))
        qrCode=ContactDataConverter.cnContactToQR_Code(cnContact: activeContact!)
        return qrCode
    }
    //get the qr code
    func getQRCode() -> UIImage{
        return qrCode
    }
    //update the array for the table view data source
    func updateContactInfoTVDataSource(){
        contactInfoArray=ContactInfoManipulator.makeContactInfoArray(cnContact: activeContact)
        contactTVDataSource.updateModel(contactInfoArray: contactInfoArray)
    }
}
