//
//  LoadPersistentContainer.swift
//  Contact Cards
//
//  Created by Matt Roberts on 5/17/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import Foundation
import CoreData
func loadPersistentContainer() -> NSPersistentCloudKitContainer {
	let container=NSPersistentCloudKitContainer(name: "ContactCards")
	let groupIdentifier="group.com.apps.celeritas.contact.cards"
	if let fileContainerURL=FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupIdentifier) {
		let storeURL=fileContainerURL.appendingPathComponent("ContactCards.sqlite")
		let storeDescription=NSPersistentStoreDescription(url: storeURL)
		storeDescription.cloudKitContainerOptions=NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.com.apps.celeritas.ContactCards")
		/*
		let remoteChangeKey = "NSPersistentStoreRemoteChangeNotificationOptionKey"
		storeDescription.setOption(true as NSNumber,
										   forKey: remoteChangeKey)
		storeDescription.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
*/
		container.persistentStoreDescriptions=[storeDescription]
	}
	//container.persistentStoreDescriptions
	container.loadPersistentStores { (_, error) in
		print("abcd"+error.debugDescription)
	}
	return container
}
