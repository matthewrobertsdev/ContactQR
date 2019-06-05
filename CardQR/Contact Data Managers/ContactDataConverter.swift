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
class ContactDataConverter{
    
    //goes from CNContact, to v card Data, to v card String
    static func cnContactToVCardString(cnContact: CNContact)->String{
        let vCardData=makeVCardData(cnContact: cnContact)
        return makeVCardString(vCardData: vCardData)
    }
    
    //goes from CNContact, to v card Data, to qr code UIImage
    static func cnContactToQR_Code(cnContact: CNContact)->UIImage{
        let vCardData=makeVCardData(cnContact: cnContact)
        let qrCodeImage=makeQRCode(vCardData: vCardData)
        return qrCodeImage
    }
    
    
    //goes from CnContact to Data
    static func makeVCardData(cnContact: CNContact)->Data{
        var vCardData=Data()
        do{
            try vCardData=CNContactVCardSerialization.data(with: [cnContact])
        }
        catch{
            print ("CNConact not serialized./n"+"Error is:/n"+error.localizedDescription)
            return vCardData
        }
        return vCardData
    }
    
    //goes from v card Data to String
    static func makeVCardString(vCardData: Data)->String{
        return String(data: vCardData, encoding: .utf8) ?? "vCard data was nil"
    }
    
    ///goes from v card Data to UIImage
    static func makeQRCode(vCardData: Data)->UIImage{
        if let filter = CIFilter(name: "CIQRCodeGenerator"){
            filter.setValue(vCardData, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            
            if let qrCodeImage = filter.outputImage?.transformed(by: transform){
                return UIImage(ciImage: qrCodeImage)
            }
            else{
                print("Unable to make qrCodeImage from data with filter")
                return UIImage()
            }
        }
        else{
            print("Unable to find CIFilter named CIQRCodeGenerator")
            return UIImage()
        }
    }
    

    
}
