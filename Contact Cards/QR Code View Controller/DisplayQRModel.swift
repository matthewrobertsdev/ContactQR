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
class DisplayQRModel {
    private var contact=CNContact()
    private var qrCode=UIImage()
	init() {
		guard let vCardString=ActiveContactCard.shared.contactCard?.vCardString else {
			return
		}
		do {
			let contactArray=try ContactDataConverter.createCNContactArray(vCardString: vCardString)
			if contactArray.count==1 {
				contact=contactArray[0]
			}
		} catch {
			print("Error making CNContact from VCard String.")
		}
	}
    func makeQRCode() -> UIImage? {
		return ContactDataConverter.cnContactToQR_Code(cnContact: contact)
    }
	func getContactCardTitle() -> String {
		if let filename=ActiveContactCard.shared.contactCard?.filename {
			return filename
		} else {
			return ""
		}
	}
}
