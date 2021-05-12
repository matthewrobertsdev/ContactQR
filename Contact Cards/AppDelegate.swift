//
//  AppDelegate.swift
//  CardQR
//
//  Created by Matt Roberts on 12/6/18.
//  Copyright © 2018 Matt Roberts. All rights reserved.
//
import UIKit
import CoreData
import ClockKit
import WatchConnectivity
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
	var session: WCSession?
	func applicationDidFinishLaunching(_ application: UIApplication) {
		if WCSession.isSupported() {
			session = WCSession.default
			session?.activate()
		}
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
		saveContext()
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
		let editContactInfoCommand =
			UICommand(title: "Edit Contact Info", image: nil, action: #selector(editContactInfo),
										 propertyList: nil, alternates: [], discoverabilityTitle: "Edit Contact Info", attributes: [], state: .off)
		let editColorCommand =
			UICommand(title: "Edit Card Color", image: nil, action: #selector(editColor),
										 propertyList: nil, alternates: [], discoverabilityTitle: "Edit Card Color", attributes: [], state: .off)
		let editTitleCommand =
			UICommand(title: "Edit Card Title", image: nil, action: #selector(editTitle),
										 propertyList: nil, alternates: [], discoverabilityTitle: "Edit Card Title", attributes: [], state: .off)
		let editCardMenu = UIMenu(title: "Edit Contact Card", image: nil, identifier: UIMenu.Identifier("editContactCard"),
									 options: .displayInline, children: [editContactInfoCommand, editColorCommand, editTitleCommand])
		let deleteCardCommand =
			UICommand(title: "Delete Contact Card", image: nil, action: #selector(deleteContact),
										 propertyList: nil, alternates: [], discoverabilityTitle: "Delete Contact Card", attributes: [], state: .off)
		let editAndDeleteMenu = UIMenu(title: "", image: nil, identifier:
										UIMenu.Identifier("editAndDeleteMenu"), options: .displayInline, children: [editCardMenu, deleteCardCommand])
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
		let openFaqCommand = UICommand(title: "Frequently Asked Questions", image: nil, action:
									#selector(openFAQ), propertyList: nil, alternates: [],
								   discoverabilityTitle: "Frequently Asked Questions", attributes: [], state: .off)
		let opneHomepageCommand = UICommand(title: "Homepage", image: nil, action:
									#selector(openHomepage), propertyList: nil, alternates: [],
								   discoverabilityTitle: "Homepage", attributes: [], state: .off)
		let openContactCommand = UICommand(title: "Contact the Developer", image: nil, action:
									#selector(openContactTheDeveloper), propertyList: nil, alternates: [],
								   discoverabilityTitle: "Contact the Developer", attributes: [], state: .off)
		let openPprivacyCommand = UICommand(title: "Privacy Policy", image: nil, action:
									#selector(openPrivacyPolicy), propertyList: nil, alternates: [],
								   discoverabilityTitle: "Privacy Policy", attributes: [], state: .off)
		let websiteMenu = UIMenu(title: "", image: nil, identifier:
										UIMenu.Identifier("websiteMenu"), options: .displayInline, children:
											[openFaqCommand, opneHomepageCommand, openContactCommand, openPprivacyCommand])
		builder.insertChild(websiteMenu, atStartOfMenu: .help)
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
			action==#selector(deleteContact) || action==#selector(editContactInfo) || action==#selector(editColor) || action==#selector(editTitle) {
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
	@objc func editContactInfo() {
		NotificationCenter.default.post(name: .editContactInfo, object: nil)
	}
	@objc func editColor() {
		NotificationCenter.default.post(name: .editColor, object: nil)
	}
	@objc func editTitle() {
		NotificationCenter.default.post(name: .editTitle, object: nil)
	}
	@objc func doNothing() {
	}
	@objc func openFAQ() {
		if let url = URL(string: "https://matthewrobertsdev.github.io/celeritasapps/#/faq") {
			UIApplication.shared.open(url)
		}
	}
	@objc func openHomepage() {
		if let url = URL(string: "https://matthewrobertsdev.github.io/celeritasapps/#/") {
			UIApplication.shared.open(url)
		}
	}
	@objc func openContactTheDeveloper() {
		if let url = URL(string: "https://matthewrobertsdev.github.io/celeritasapps/#/contact") {
			UIApplication.shared.open(url)
		}
	}
	@objc func openPrivacyPolicy() {
		if let url = URL(string: "https://matthewrobertsdev.github.io/celeritasapps/#/privacy") {
			UIApplication.shared.open(url)
		}
	}
	lazy var persistentContainer: NSPersistentCloudKitContainer = {
		let container=NSPersistentCloudKitContainer(name: "ContactCards")
		let groupIdentifier="group.com.apps.celeritas.contact.cards"
		if let fileContainerURL=FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupIdentifier) {
			let storeURL=fileContainerURL.appendingPathComponent("ContactCards.sqlite")
			let storeDescription=NSPersistentStoreDescription(url: storeURL)
			storeDescription.cloudKitContainerOptions=NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.com.apps.celeritas.ContactCards")
			container.persistentStoreDescriptions=[storeDescription]
		}
		//container.persistentStoreDescriptions
		container.loadPersistentStores { (_, error) in
			print(error.debugDescription)
		}
		return container
	}()
	func saveContext () {
			let context = persistentContainer.viewContext
			if context.hasChanges {
				do {
					try context.save()
				} catch {
					print(error.localizedDescription)
				}
			}
		}

}
