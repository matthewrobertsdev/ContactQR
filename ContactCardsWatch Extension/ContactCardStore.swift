//
//  ContactCardStore.swift
//  ContactCardsWatch Extension
//
//  Created by Matt Roberts on 6/22/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import Foundation
import CoreData
class ContactCardStore {
	lazy var container=loadPersistentCloudKitContainer()
	static let shared=ContactCardStore()
	var fetchedResultsController: NSFetchedResultsController<ContactCardMO>?
	private init() {
	}
	func loadCards(delegate: NSFetchedResultsControllerDelegate) {
		container.viewContext.automaticallyMergesChangesFromParent=true
		let contactCardFetchRequest = NSFetchRequest<ContactCardMO>(entityName: "ContactCard")
				let sortDescriptor = NSSortDescriptor(key: "filename", ascending: true)
		contactCardFetchRequest.sortDescriptors = [sortDescriptor]
		let context=container.viewContext
		self.fetchedResultsController = NSFetchedResultsController<ContactCardMO>(
					fetchRequest: contactCardFetchRequest,
					managedObjectContext: context,
					sectionNameKeyPath: nil,
					cacheName: nil)
		fetchedResultsController?.delegate=delegate
		do {
			try fetchedResultsController?.performFetch()
			} catch {
				print("error performing fetch \(error.localizedDescription)")
			}
	}
	func assignActiveContact() {
		if let updatedContactCard=fetchedResultsController?.fetchedObjects?.first(where: { contactCard in
			if let currentObjectID=ActiveContactCard.shared.contactCard?.objectID {
				return contactCard.objectID==currentObjectID
			} else {
				return false
			}
		}) {
			ActiveContactCard.shared.contactCard=updatedContactCard
		} else {
			ActiveContactCard.shared.contactCard=nil
		}
	}
}
