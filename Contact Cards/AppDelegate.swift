//
//  AppDelegate.swift
//  CardQR
//
//  Created by Matt Roberts on 12/6/18.
//  Copyright © 2018 Matt Roberts. All rights reserved.
//
import UIKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
	func applicationDidFinishLaunching(_ application: UIApplication) {
	}
    func application(_ application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    func applicationWillResignActive(_ application: UIApplication) {
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    func applicationWillTerminate(_ application: UIApplication) {
		//ContactCardStore.sharedInstance.saveContacts()
    }
	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}
	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
	}
	override func buildMenu(with builder: UIMenuBuilder) {
		super.buildMenu(with: builder)
		print("Hello iPad")
		guard builder.system == UIMenuSystem.main else {
			return
		}
		builder.remove(menu: .format)
		builder.remove(menu: .services)
		builder.remove(menu: .toolbar)
		builder.replaceChildren(ofMenu: .help) { _ in
			[]
		}
		let editCardCommand =
			UICommand(title: "Edit Contact Card", image: nil, action: #selector(editContact),
										 propertyList: nil, alternates: [], discoverabilityTitle: "Edit Contact Card", attributes: [], state: .off)
		let deleteCardCommand =
			UICommand(title: "Delete Contact Card", image: nil, action: #selector(deleteContact),
										 propertyList: nil, alternates: [], discoverabilityTitle: "Delete Contact Card", attributes: [], state: .off)
		let editAndDeleteMenu = UIMenu(title: "", image: nil, identifier:
										UIMenu.Identifier("editAndDeleteMenu"), options: .displayInline, children: [editCardCommand, deleteCardCommand])
		builder.insertChild(editAndDeleteMenu, atStartOfMenu: .edit)
		let exportAsVCardCommand =
			UIKeyCommand(title: NSLocalizedString("Export as vCard...", comment: ""),
						 image: nil,
						 action: #selector(exportAsVCard),
						 input: "e",
						 modifierFlags: .command,
						 propertyList: nil)
		exportAsVCardCommand.discoverabilityTitle = NSLocalizedString("Export as vCard...", comment: "")
		let exportAsVCardMenu = UIMenu(title: "", image: nil, identifier:
										UIMenu.Identifier("exportAsVCard"), options: .displayInline, children: [exportAsVCardCommand])
		builder.insertChild(exportAsVCardMenu, atStartOfMenu: .file)
		let newContactCommand =
			UIKeyCommand(title: NSLocalizedString("New Contact Card", comment: ""),
						 image: nil,
						 action: #selector(createNewContact),
						 input: "n",
						 modifierFlags: .command,
						 propertyList: nil)
		newContactCommand.discoverabilityTitle = NSLocalizedString("New Contact Card", comment: "")
		let contactFromContactCommand =
			UIKeyCommand(title: NSLocalizedString("New Card From Contact", comment: ""),
						 image: nil,
						 action: #selector(newCardFromContact),
						 input: "n",
						 modifierFlags: UIKeyModifierFlags(arrayLiteral: [.command, .shift]),
						 propertyList: nil)
		contactFromContactCommand.discoverabilityTitle = NSLocalizedString("New Card From Contact", comment: "")
		let newContactMenu = UIMenu(title: "", image: nil, identifier:
										UIMenu.Identifier("newContactMenu"), options: .displayInline, children: [newContactCommand, contactFromContactCommand])
		builder.insertChild(newContactMenu, atStartOfMenu: .file)
		let showQRCommand =
			UIKeyCommand(title: NSLocalizedString("Show QR Code", comment: ""),
						 image: nil,
						 action: #selector(showQRCode),
						 input: "1",
						 modifierFlags: .command,
						 propertyList: nil)
		exportAsVCardCommand.discoverabilityTitle = NSLocalizedString("Export as vCard...", comment: "")
		let showQRMenu = UIMenu(title: "Show QR Code", image: nil, identifier:
										UIMenu.Identifier("showQRCode"), options: .displayInline, children: [showQRCommand])
		let shareCommand = UICommand(title: "Share", image: nil, action: #selector(share),
									 propertyList: UICommandTagShare, alternates: [], discoverabilityTitle: "Share", attributes: [], state: .on)
		let shareMenu = UIMenu(title: "Share", image: nil, identifier:
										UIMenu.Identifier("share"), options: .displayInline, children: [shareCommand])
		let cardMenu = UIMenu(title: "Card", image: nil, identifier:
								UIMenu.Identifier("cardMenu"), options: [], children: [showQRMenu, shareMenu])
		builder.insertSibling(cardMenu, beforeMenu: .window)
	}
	@objc func exportAsVCard() {
		NotificationCenter.default.post(name: .exportAsVCard, object: self)
	}
	@objc func showQRCode() {
		NotificationCenter.default.post(name: .showQRCode, object: self)
	}
	override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
		guard let splitViewController = SceneDelegate.mainsSplitViewController else {
			return false
		}
		if action==#selector(exportAsVCard) || action==#selector(showQRCode) ||
			action==#selector(deleteContact) || action==#selector(editContact) {
			guard let contactCardViewController=splitViewController.viewController(for: .secondary)
					as? ContactCardViewController else {
				return false
			}
			if contactCardViewController.contactCard != nil {
				return AppState.shared.appState==AppStateValue.isNotModal
			}
			return false
		} else if action==#selector(createNewContact)||action==#selector(newCardFromContact) {
			return AppState.shared.appState==AppStateValue.isNotModal
		} else {
			return super.canPerformAction(action, withSender: nil)
		}
	}
	@objc func share() {
	}
	@objc func createNewContact() {
		NotificationCenter.default.post(name: .createNewContact, object: nil)
	}
	@objc func newCardFromContact() {
		NotificationCenter.default.post(name: .createNewContactFromContact, object: nil)
	}
	@objc func deleteContact() {
		NotificationCenter.default.post(name: .deleteContact, object: nil)
	}
	@objc func editContact() {
		NotificationCenter.default.post(name: .editContact, object: nil)
	}
}
extension Notification.Name {
	static let showQRCode=Notification.Name("show-QR-code")
	static let exportAsVCard=Notification.Name("export-as-vCard")
	static let createNewContact=Notification.Name("create-new-contact")
	static let createNewContactFromContact=Notification.Name("create-new-contact-from-contact")
	static let deleteContact=Notification.Name("delete-contact")
	static let editContact=Notification.Name("edit-contact")
	static let shareContact=Notification.Name("share-contact")
}
