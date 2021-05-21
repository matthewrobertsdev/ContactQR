//
//  ContactDataConversion.swift
//  CardQR
//
//  Created by Matt Roberts on 12/20/18.
//  Copyright © 2018 Matt Roberts. All rights reserved.
//

import Contacts
import UIKit
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
	#if os(watchOS)
	#else
    //goes from CNContact, to v card Data, to v card String
    static func cnContactToVCardString(cnContact: CNContact) -> String {
        let vCardData=makeVCardData(cnContact: cnContact)
        return makeVCardString(vCardData: vCardData)
    }
    //goes from CNContact, to v card Data, to qr code UIImage
    static func cnContactToQR_Code(cnContact: CNContact) -> UIImage? {
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
    static func makeQRCode(string: String) -> UIImage? {
        let data = string.data(using: .utf8) ?? Data()
        return makeQRCode(data: data)
    }
    //goes from v card Data to UIImage
    static func makeQRCode(data: Data) -> UIImage? {
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            if let qrCodeImage = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: qrCodeImage)
            } else {
                print("Unable to make qrCodeImage from data with filter")
                return nil
            }
        } else {
            print("Unable to find CIFilter named CIQRCodeGenerator")
            return nil
        }
    }
	static func writeTemporaryFile(contactCard: ContactCardMO, directoryURL: URL) -> URL? {
		var filename="Contact"
		var contact=CNContact()
		do {
			let contactArray=try ContactDataConverter.createCNContactArray(vCardString: contactCard.vCardString)
			if contactArray.count==1 {
				contact=contactArray[0]
			}
		} catch {
			print("Error making CNContact from VCard String.")
		}
		if let name=CNContactFormatter().string(from: contact) {
			filename=name
		}
		let fileURL = directoryURL.appendingPathComponent(filename)
			.appendingPathExtension("vcf")
		do {
		let data = try CNContactVCardSerialization.data(with: [contact])

		try data.write(to: fileURL, options: [.atomicWrite])
		} catch {
			print("Error trying to make vCard file")
			return nil
		}
		return fileURL
	}
	static func writeArchive(contactCards: [ContactCard], directoryURL: URL, fileExtension: String) -> URL? {
		let filename="Contact Cards"
		let fileURL = directoryURL.appendingPathComponent(filename)
			.appendingPathExtension(fileExtension)
			if let data=encodeData(contactCards: contactCards) {
				do {
					try data.write(to: fileURL, options: [.atomicWrite])
				} catch {
					print("Error trying to make write archive")
					return nil
				}
			} else {
				return nil
			}
		print("Successfully wrote .contactcards archive.")
		return fileURL
	}
	static func encodeData(contactCards: [ContactCard]) -> Data? {
		do {
			let encoder=JSONEncoder()
			encoder.outputFormatting = .prettyPrinted
			return try encoder.encode(contactCards)
		} catch {
			print("Error trying to make write archive")
			return nil
		}
	}
	static func readArchive(url: URL) -> [ContactCard]? {
		do {
			guard url.startAccessingSecurityScopedResource() else {
							print("Can't access archive")
							return nil
					}
			let decoder=JSONDecoder()
			let data=try Data(contentsOf: url)
			defer { url.stopAccessingSecurityScopedResource() }
			return try decoder.decode([ContactCard].self, from: data)
		} catch {
			print("Error trying to decode data")
			return nil
		}
	}
	#endif
}
enum DataConversionError: Error {
    case dataSerializationError(String)
    case badVCard(String)
}
