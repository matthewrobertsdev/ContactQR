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
		"com.apps.celeritas.Air.Contacts.deleteCard")
	static let editContact = NSToolbarItem.Identifier(
		"com.apps.celeritas.Air.Contacts.editCard")
	static let exportCard = NSToolbarItem.Identifier(
		"com.apps.celeritas.Air.Contacts.exportCard")
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
			.toggleSidebar, .shareCard, .showQRCode, .newCardFromContact, .newContactCard, .exportCard, .editContact, .deleteCard
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
		var validCardTarget: NSObject=self
		if let uuid=UserDefaults.standard.string(forKey: ContactCardsTableViewController.selectedCardUUIDKey) {
			if let _=ContactCardStore.sharedInstance.getIndexOfContactWithUUID(uuid: uuid) {
				validCardTarget=appDelegate
			}
		}
		var toolbarItem: NSToolbarItem?
		switch itemIdentifier {
		case .toggleSidebar:
			toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
		case .editContact:
			let editContactInfoCommand =
				UICommand(title: "Edit Contact Info", image: nil, action: #selector(appDelegate.editContactInfo),
											 propertyList: nil, alternates: [], discoverabilityTitle: "Edit Contact Info", attributes: [], state: .off)
			let editColorCommand =
				UICommand(title: "Edit Card Color", image: nil, action: #selector(appDelegate.editColor),
											 propertyList: nil, alternates: [], discoverabilityTitle: "Edit Card Color", attributes: [], state: .off)
			let editTitleCommand =
				UICommand(title: "Edit Card Title", image: nil, action: #selector(appDelegate.editTitle),
											 propertyList: nil, alternates: [], discoverabilityTitle: "Edit Card Title", attributes: [], state: .off)
			let editCardMenu = UIMenu(title: "Edit Contact Card", image: nil, identifier: UIMenu.Identifier("editContactCard"),
										 options: .displayInline, children: [editContactInfoCommand, editColorCommand, editTitleCommand])
			let item = NSMenuToolbarItem(itemIdentifier: itemIdentifier)
			item.image = UIImage(systemName: "pencil")
			item.label = "Edit Card"
			item.toolTip = "Edit Card"
			//item.action = #selector(appDelegate.doNothing)
			//item.target = validCardTarget
			item.itemMenu=editCardMenu
			item.isBordered=true
			item.showsIndicator=false
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
		case .newCardFromContact:
			let item = NSToolbarItem(itemIdentifier: itemIdentifier)
			item.image = UIImage(systemName: "person.crop.circle.badge.plus")
			item.label = "New Card from Contact"
			item.toolTip = "New Card from Contact"
			item.action = #selector(appDelegate.newCardFromContact)
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
		default:
			toolbarItem = nil
		}
		return toolbarItem
	}
	@objc func doAction() {
	}
}
#endif
