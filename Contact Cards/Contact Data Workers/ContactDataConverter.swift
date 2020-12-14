//
//  ContactDataConversion.swift
//  CardQR
//
//  Created by Matt Roberts on 12/20/18.
//  Copyright © 2018 Matt Roberts. All rights reserved.
//

import ContactsUI
/*
 Converts between CNContact, v card Data, String, and QRCode
 */
class ContactDataConverter {
    static func createCNContactArray(vCardString: String)throws ->[CNContact] {
        if let vCardData = vCardString.data(using: .utf8) {
            return try CNContactVCardSerialization.contacts(with: vCardData)
        } else {
            throw DataConversionError.dataSerializationError("Couldn't serialize string to data.")
        }
    }
    //goes from CNContact, to v card Data, to v card String
    static func cnContactToVCardString(cnContact: CNContact) -> String {
        let vCardData=makeVCardData(cnContact: cnContact)
        return makeVCardString(vCardData: vCardData)
    }
    //goes from CNContact, to v card Data, to qr code UIImage
    static func cnContactToQR_Code(cnContact: CNContact) -> UIImage {
        let vCardData=makeVCardData(cnContact: cnContact)
        let qrCodeImage=makeQRCode(data: vCardData)
        return qrCodeImage
    }
    //goes from CnContact to Data
    static func makeVCardData(cnContact: CNContact) -> Data {
        var vCardData=Data()
        do {
            try vCardData=CNContactVCardSerialization.data(with: [cnContact])
        } catch {
            print ("CNConact not serialized./n"+"Error is:/n"+error.localizedDescription)
            return vCardData
        }
        return vCardData
    }
    //goes from v card Data to String
    static func makeVCardString(vCardData: Data) -> String {
        return String(data: vCardData, encoding: .utf8) ?? "Data was nil"
    }
    static func makeQRCode(string: String) -> UIImage {
        let data = string.data(using: .utf8) ?? Data()
        return makeQRCode(data: data)
    }
    ///goes from v card Data to UIImage
    static func makeQRCode(data: Data) -> UIImage {
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            if let qrCodeImage = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: qrCodeImage)
            } else {
                print("Unable to make qrCodeImage from data with filter")
                return UIImage()
            }
        } else {
            print("Unable to find CIFilter named CIQRCodeGenerator")
            return UIImage()
        }
    }
}
enum DataConversionError: Error {
    case dataSerializationError(String)
    case badVCard(String)
}