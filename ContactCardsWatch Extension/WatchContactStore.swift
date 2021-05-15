//
//  WatchContactStore.swift
//  ContactCardsWatch Extension
//
//  Created by Matt Roberts on 5/15/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import Foundation
import CoreGraphics
class WatchContactStore {
	private var colorString: String?
	private var vCard: String?
	private var title: String?
	private var imageData: Data?
	private var cardString: NSAttributedString?
	static let sharedInstance=WatchContactStore()
	private init() {
	}
	func updateData(message: [String: Any]) {
		guard let colorString=message["color"] as? String else {
			return
		}
		guard let vCard=message["vCard"] as? String else {
			return
		}
		guard let title=message["title"] as? String else {
			return
		}
		guard let imageData=message["imageData"] as? Data else {
			return
		}
		self.colorString=colorString
		self.vCard=vCard
		self.title=title
		self.imageData=imageData
		do {
			let contact=try ContactDataConverter.createCNContactArray(vCardString: vCard)[0]
			cardString=ContactInfoManipulator.makeContactDisplayString(cnContact: contact, fontSize: CGFloat(13))
		} catch {
			print("Unable to create contact from vCard for watch.")
		}
	}
	func getImageData() -> Data? {
		return imageData
	}
	func getCardString() -> NSAttributedString? {
		return cardString
	}
}
