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
	static let deleteCard = NSToolbarItem.Identifier("com.apps.celeritas.Air.Contacts.delete")
	static let toggleRecipeIsFavorite = NSToolbarItem.Identifier("com.example.apple-samplecode.Recipes.toggleRecipeIsFavorite")
}
class ToolbarDelegate: NSObject, NSToolbarDelegate {
	func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		let identifiers: [NSToolbarItem.Identifier] = [
			.toggleSidebar
		]
		return identifiers
	}
	func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		return toolbarDefaultItemIdentifiers(toolbar)
	}
	func toolbar(_ toolbar: NSToolbar,
				 itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
				 willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
		var toolbarItem: NSToolbarItem?
		switch itemIdentifier {
		case .toggleSidebar:
			toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
		default:
			toolbarItem = nil
		}
		return toolbarItem
	}
}
#endif
