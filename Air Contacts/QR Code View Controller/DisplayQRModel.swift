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
    private var qrCode: UIImage!
	init() {
		guard let vCardString=ActiveContactCard.shared.contactCard?.vCardString else {
			return
		}
		do {
			contact=try ContactDataConverter.createCNContactArray(vCardString: vCardString)[0]
			//tableView.reloadData()
		} catch {
			print("Error making CNContact from VCard String.")
		}
	}
    //get a qr code from the active contact
    func makeQRCode() -> UIImage {
        qrCode=ContactDataConverter.cnContactToQR_Code(cnContact: contact)
        return qrCode
    }
	func getContactCardTitle() -> String {
		if let filename=ActiveContactCard.shared.contactCard?.filename {
			return filename
		} else {
			return ""
		}
	}
}
