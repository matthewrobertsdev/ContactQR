//
//  NotificationNameExtensions.swift
//  Contact Cards
//
//  Created by Matt Roberts on 3/14/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import Foundation
extension Notification.Name {
	static let showQRCode=Notification.Name("show-QR-code")
	static let exportAsVCard=Notification.Name("export-as-vCard")
	static let createNewContact=Notification.Name("create-new-contact")
	static let createNewContactFromContact=Notification.Name("create-new-contact-from-contact")
	static let deleteContact=Notification.Name("delete-contact")
	static let editContact=Notification.Name("edit-contact")
	static let shareContact=Notification.Name("share-contact")
	static let contactDeleted=Notification.Name("contact-deleted")
	static let modalityChanged=Notification.Name("modality-changed")
	static let watchContactUpdated=Notification.Name("watch-contact-updated")
	static let manageCards=Notification.Name("manage-cards")
	static let deleteAllCards=Notification.Name("delete-all-cards")
	static let siriCardChosen=Notification.Name("siri-card-chosen")
	static let cardsLoaded=Notification.Name("cards-loaded")
	/*
	 Post this WHENEVER ActiveContact.shared.activeContact changes
	 */
	static let contactChanged=Notification.Name("contact-changed")

}
