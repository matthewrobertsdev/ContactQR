//
//  UpdateCards.swift
//  Contact Cards
//
//  Created by Matt Roberts on 6/18/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import Foundation
import WidgetKit
import CoreData
let appGroupKey="group.com.apps.celeritas.contact.cards"
func updateWidget(contactCard: ContactCardMO?) {
	WidgetCenter.shared.getCurrentConfigurations { result in
		guard case .success(let widgets) = result else { return }
		if let widget = widgets.first(
			where: { widget in
				let intent = widget.configuration as? ConfigurationIntent
				if let contactCard=contactCard {
					return intent?.parameter?.identifier == contactCard.objectID.uriRepresentation().absoluteString
				} else {
					return false
				}
			}
		) {
			WidgetCenter.shared.reloadTimelines(ofKind: widget.kind)
		}
	}
}
func updateAllWidgets() {
	WidgetCenter.shared.getCurrentConfigurations { result in
		guard case .success( _) = result else { return }
			WidgetCenter.shared.reloadAllTimelines()
		}
}
func updateSiriCard(contactCard: ContactCardMO?) {
	if let card=contactCard {
		UserDefaults(suiteName: appGroupKey)?.set(card.color, forKey: SiriCardKeys.chosenCardColor.rawValue)
		UserDefaults(suiteName: appGroupKey)?.set(card.qrCodeImage, forKey: SiriCardKeys.chosenCardImageData.rawValue)
		UserDefaults(suiteName: appGroupKey)?.set(card.objectID.uriRepresentation().absoluteString, forKey: SiriCardKeys.chosenCardObjectID.rawValue)
		UserDefaults(suiteName: appGroupKey)?.set(card.filename, forKey: SiriCardKeys.chosenCardTitle.rawValue)
	} else {
		UserDefaults(suiteName: appGroupKey)?.set(nil, forKey: SiriCardKeys.chosenCardColor.rawValue)
		UserDefaults(suiteName: appGroupKey)?.set(nil, forKey: SiriCardKeys.chosenCardImageData.rawValue)
		UserDefaults(suiteName: appGroupKey)?.set(nil, forKey: SiriCardKeys.chosenCardObjectID.rawValue)
		UserDefaults(suiteName: appGroupKey)?.set(nil, forKey: SiriCardKeys.chosenCardTitle.rawValue)
	}
}
func updateCards(fetchedResultsController: NSFetchedResultsController<ContactCardMO>) {
	updateActiveCard(fetchedResultsController: fetchedResultsController)
	updateAllWidgets()
	if let contactCards=fetchedResultsController.fetchedObjects {
		let userDefaults=UserDefaults(suiteName: appGroupKey)
		let siriCard=contactCards.first(where: { contactCard in
			contactCard.objectID.uriRepresentation().absoluteURL.absoluteString==userDefaults?.string(forKey: SiriCardKeys.chosenCardObjectID.rawValue)
		})
		updateSiriCard(contactCard: siriCard)
	}
}
func updateActiveCard(fetchedResultsController: NSFetchedResultsController<ContactCardMO>) {
	if let activeContactCard=ActiveContactCard.shared.contactCard {
		if let contactCard=fetchedResultsController.fetchedObjects?.first(where: { contactCard in
			contactCard.objectID==activeContactCard.objectID
		}) {
			ActiveContactCard.shared.contactCard=contactCard
		} else {
			ActiveContactCard.shared.contactCard=nil
		}
		NotificationCenter.default.post(name: .contactUpdated, object: nil)
	}
}
