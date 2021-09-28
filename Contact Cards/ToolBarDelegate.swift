//
//  ToolBarDelegate.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/27/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import UIKit
#if targetEnvironment(macCatalyst)
extension NSToolbarItem.Identifier {
	static let deleteCard = NSToolbarItem.Identifier(
		"com.apps.celeritas.ContactCards.deleteCard")
	static let editContact = NSToolbarItem.Identifier(
		"com.apps.celeritas.ContactCards.editCard")
	static let exportCard = NSToolbarItem.Identifier(
		"com.apps.celeritas.ContactCards.exportCard")
	static let newContactCard = NSToolbarItem.Identifier(
		"com.apps.celeritas.ContactCards.newCard")
	static let showQRCode = NSToolbarItem.Identifier(
		"com.apps.celeritas.ContactCards.showQRCode")
	static let shareCard = NSToolbarItem.Identifier(
		"com.apps.celeritas.AContactCards.shareCard")
	static let manageCards = NSToolbarItem.Identifier(
		"com.apps.celeritas.ContactCards.manageCards")
}
class ToolbarDelegate: NSObject, NSToolbarDelegate {
	func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		let identifiers: [NSToolbarItem.Identifier] = [
			.toggleSidebar, .shareCard, .showQRCode, .newContactCard, .editContact, .exportCard, .deleteCard, .manageCards
		]
		return identifiers
	}
	func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		return toolbarDefaultItemIdentifiers(toolbar)
	}
	func toolbar(_ toolbar: NSToolbar,
				 itemForItemIdentifier itemIdentifier:
					NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
		guard let appDelegate=UIApplication.shared.delegate as? AppDelegate else {
			return nil
		}
		guard let contactCardViewController=SceneDelegate.mainsSplitViewController?.viewController(for: .secondary) as? ContactCardViewController else {
			return nil
		}
		let validCardTarget: NSObject=self
		var toolbarItem: NSToolbarItem?
		switch itemIdentifier {
		case .toggleSidebar:
			toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
		case .editContact:
			let item = NSToolbarItem(itemIdentifier: itemIdentifier)
			item.image = UIImage(systemName: "pencil")
			item.label = "Edit Card"
			item.toolTip = "Edit Card"
			item.action = #selector(appDelegate.editContactInfo)
			item.target = validCardTarget
			item.isBordered=true
			toolbarItem = item
		case .deleteCard:
			let item = NSToolbarItem(itemIdentifier: itemIdentifier)
			item.image = UIImage(systemName: "trash")
			item.label = "Delete Card"
			item.toolTip = "Delete Card"
			item.action = #selector(appDelegate.deleteContact)
			item.target = validCardTarget
			item.isBordered=true
			toolbarItem = item
		case .exportCard:
			let item = NSToolbarItem(itemIdentifier: itemIdentifier)
			item.image = UIImage(systemName: "doc.badge.plus")
			item.label = "Export Card"
			item.toolTip = "Export Card"
			item.action = #selector(appDelegate.exportAsVCard)
			item.target = validCardTarget
			item.isBordered=true
			toolbarItem = item
		case .newContactCard:
			let item = NSToolbarItem(itemIdentifier: itemIdentifier)
			item.image = UIImage(systemName: "plus")
			item.label = "New Contact Card"
			item.toolTip = "New Contact Card"
			item.action = #selector(appDelegate.createNewContact)
			item.target = appDelegate
			item.isBordered=true
			toolbarItem = item
		case .showQRCode:
			let item = NSToolbarItem(itemIdentifier: itemIdentifier)
			item.image = UIImage(systemName: "qrcode")
			item.label = "Show QR Code"
			item.toolTip = "Show QR Code"
			item.action = #selector(appDelegate.showQRCode)
			item.target = validCardTarget
			item.isBordered=true
			toolbarItem = item
		case .shareCard:
			let item = NSSharingServicePickerToolbarItem(itemIdentifier: .shareCard)
			item.activityItemsConfiguration=contactCardViewController
			item.image = UIImage(systemName: "square.and.arrow.up")
			item.label = "Share"
			item.toolTip = "Share"
			item.action = #selector(appDelegate.share)
			item.target = appDelegate
			item.isBordered=true
			toolbarItem = item
		case .manageCards:
			let item = NSToolbarItem(itemIdentifier: itemIdentifier)
			item.image = UIImage(systemName: "gearshape")
			item.label = "Manage Cards"
			item.toolTip = "Manage Cards"
			item.action = #selector(appDelegate.manageCards)
			item.target = appDelegate
			item.isBordered=true
			toolbarItem = item
		default:
			toolbarItem = nil
		}
		return toolbarItem
	}
	@objc func doAction() {
	}
}
#endif
