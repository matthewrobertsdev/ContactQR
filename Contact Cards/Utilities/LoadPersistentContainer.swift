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
		#if os(watchOS)
		#else
		let keyValueStore=NSUbiquitousKeyValueStore.default
		if !keyValueStore.bool(forKey: "iCloudSync") {
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
func iCloudExplanationString() -> String {
	var syncMessage="If you are signed into iCloud on your "
	syncMessage+="device and haven’t turned it off for Contact Cards, "
	syncMessage+="your cards created with the app should sync with iCloud.  "
	syncMessage+="If you do not want this, you should turn iCloud off for Contact Cards "
	#if targetEnvironment(macCatalyst)
	syncMessage+="in the System Preferences app under Apple ID>iCloud>iCloud Drive Options>Contact Cards.  If you already have cards created, you can delete them from iCloud "
	#else
	syncMessage+="in the Settings app under Apple ID>iCloud>Contact Cards.  If you already have cards created, you can delete them from iCloud "
	#endif
	return syncMessage
}
