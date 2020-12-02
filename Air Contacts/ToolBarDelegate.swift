//
//  ToolBarDelegate.swift
//  Air Contacts
//
//  Created by Matt Roberts on 11/27/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import UIKit
#if targetEnvironment(macCatalyst)
extension NSToolbarItem.Identifier {
	static let deleteCard = NSToolbarItem.Identifier(
		"com.apps.celeritas.Air.Contacts.delete")
	static let editCard = NSToolbarItem.Identifier(
		"com.apps.celeritas.Air.Contacts.edit")
	static let exportCard = NSToolbarItem.Identifier(
		"com.apps.celeritas.Air.Contacts.export")
	static let newContactCard = NSToolbarItem.Identifier(
		"com.apps.celeritas.Air.Contacts.newCard")
	static let newCardFromContact = NSToolbarItem.Identifier(
		"com.apps.celeritas.Air.Contacts.newCardFromContact")
	static let showQRCode = NSToolbarItem.Identifier(
		"com.apps.celeritas.Air.Contacts.showQRCode")
	static let shareCard = NSToolbarItem.Identifier(
		"com.apps.celeritas.Air.Contacts.shareCard")
}
class ToolbarDelegate: NSObject, NSToolbarDelegate {
	func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		let identifiers: [NSToolbarItem.Identifier] = [
			.toggleSidebar, .newCardFromContact, .newContactCard, .showQRCode, .shareCard, .exportCard, .editCard, .deleteCard
		]
		return identifiers
	}
	func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		return toolbarDefaultItemIdentifiers(toolbar)
	}
	func toolbar(_ toolbar: NSToolbar,
				 itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
				 willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
		guard let appDelegate=UIApplication.shared.delegate as? AppDelegate else {
			return nil
		}
		guard let contactCardViewController=SceneDelegate.mainsSplitViewController?.viewController(for: .secondary) as? ContactCardViewController else {
			return nil
		}
		var toolbarItem: NSToolbarItem?
		switch itemIdentifier {
		case .toggleSidebar:
			toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
		case .editCard:
			let item = NSToolbarItem(itemIdentifier: itemIdentifier)
			item.image = UIImage(systemName: "pencil")
			item.label = "Edit Card"
			item.toolTip = "Edit Card"
			item.action = #selector(doAction)
			item.target = self
			toolbarItem = item
		case .deleteCard:
			let item = NSToolbarItem(itemIdentifier: itemIdentifier)
			item.image = UIImage(systemName: "trash")
			item.label = "Delete Card"
			item.toolTip = "Delete Card"
			item.action = #selector(doAction)
			item.target = self
			toolbarItem = item
		case .exportCard:
			let item = NSToolbarItem(itemIdentifier: itemIdentifier)
			item.image = UIImage(systemName: "doc.badge.plus")
			item.label = "Export Card"
			item.toolTip = "Export Card"
			item.action = #selector(appDelegate.exportAsVCard)
			item.target = appDelegate
			toolbarItem = item
		case .newContactCard:
			let item = NSToolbarItem(itemIdentifier: itemIdentifier)
			item.image = UIImage(systemName: "plus")
			item.label = "New Contact Card"
			item.toolTip = "New Contact Card"
			item.action = #selector(appDelegate.createNewContact)
			item.target = appDelegate
			toolbarItem = item
		case .newCardFromContact:
			let item = NSToolbarItem(itemIdentifier: itemIdentifier)
			item.image = UIImage(systemName: "person.crop.circle.badge.plus")
			item.label = "New Card from Contact"
			item.toolTip = "New Card from Contact"
			item.action = #selector(appDelegate.newCardFromContact)
			item.target = appDelegate
			toolbarItem = item
		case .showQRCode:
			let item = NSToolbarItem(itemIdentifier: itemIdentifier)
			item.image = UIImage(systemName: "qrcode")
			item.label = "Show QR Code"
			item.toolTip = "Show QR Code"
			item.action = #selector(appDelegate.showQRCode)
			item.target = appDelegate
			toolbarItem = item
		case .shareCard:
			let item = NSSharingServicePickerToolbarItem(itemIdentifier: .shareCard)
			item.activityItemsConfiguration=contactCardViewController
			item.image = UIImage(systemName: "square.and.arrow.up")
			item.label = "Share"
			item.toolTip = "Share"
			item.action = #selector(appDelegate.share)
			item.target = appDelegate
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
