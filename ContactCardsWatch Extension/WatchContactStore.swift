//
//  WatchContactStore.swift
//  ContactCardsWatch Extension
//
//  Created by Matt Roberts on 5/15/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import Foundation
import WatchKit
import CoreGraphics
class WatchContactStore {
	private var colorString=""
	private var vCard=""
	private var title=""
	private var imageData=UIImage().pngData()
	private var cardString=NSAttributedString()
	private let colorModel=ColorModel()
	static let sharedInstance=WatchContactStore()
	private init() {
	}
	func updateData(contactCardMO: ContactCardMO) {
		self.colorString=contactCardMO.color
		self.vCard=contactCardMO.vCardString
		self.title=contactCardMO.filename
		self.imageData=UIImage().pngData()
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
	func getTitle() -> String? {
		return title
	}
	func getColor() -> UIColor? {
		return colorModel.getColorsDictionary()[colorString] ?? UIColor.white
	}
}
