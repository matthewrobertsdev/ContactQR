//
//  LoadPersistentContainer.swift
//  Contact Cards
//
//  Created by Matt Roberts on 5/17/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import Foundation
import CoreData
func loadPersistentContainer(neverSync: Bool) -> NSPersistentCloudKitContainer {
	let container=NSPersistentCloudKitContainer(name: "ContactCards")
	let groupIdentifier="group.com.apps.celeritas.contact.cards"
	if let fileContainerURL=FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupIdentifier) {
		let storeURL=fileContainerURL.appendingPathComponent("ContactCards.sqlite")
		let storeDescription=NSPersistentStoreDescription(url: storeURL)
		storeDescription.cloudKitContainerOptions=NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.com.apps.celeritas.ContactCards")
		#if os(watchOS)
		#else
		let keyValueStore=NSUbiquitousKeyValueStore.default
		if !keyValueStore.bool(forKey: "iCloudSync") || neverSync {
			storeDescription.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
			storeDescription.cloudKitContainerOptions=nil
		}
		#endif
		container.persistentStoreDescriptions=[storeDescription]
	}
	container.loadPersistentStores { (_, error) in
		print(error.debugDescription)
	}
	return container
}
