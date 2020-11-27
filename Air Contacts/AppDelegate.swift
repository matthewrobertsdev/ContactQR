//
//  AppDelegate.swift
//  CardQR
//
//  Created by Matt Roberts on 12/6/18.
//  Copyright © 2018 Matt Roberts. All rights reserved.
//
import UIKit
import WatchConnectivity
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
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
	override func buildMenu(with builder: UIMenuBuilder) {
		super.buildMenu(with: builder)
		guard builder.system == UIMenuSystem.main else {
			return
		}
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
		guard let splitViewController = self.window?.rootViewController as? UISplitViewController else {
			return
		}
		guard let contactCardViewController=splitViewController.viewController(for: .secondary) as? ContactCardViewController else {
			return
		}
		let shareCommand = UICommand(title: "Share", image: nil, action: #selector(contactCardViewController.share(_:)),
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
		guard let splitViewController = self.window?.rootViewController as? UISplitViewController else {
			return false
		}
		if action==#selector(exportAsVCard) || action==#selector(showQRCode) {
			guard let contactCardViewController=splitViewController.viewController(for: .secondary) as? ContactCardViewController else {
				return false
			}
			guard let _=contactCardViewController.contactCard else {
				return false
			}
			return AppState.shared.appState==AppStateValue.isNotModal
		} else {
			return super.canPerformAction(action, withSender: nil)
		}
	}
//*/
	/*
	override func validate(_ command: UICommand) {
  
		guard let appDelegate=UIApplication.shared.delegate as? AppDelegate else {
			print("app delegate was nil")
			return super.validate(command)
		}
		if command.action==#selector(appDelegate.exportAsVCard) {
			print("for exportToVCard")
			command.state = .off
		} else {
			super.validate(command)
		}
	}
	*/
	@objc func share(){
		
	}
}
extension Notification.Name {
	static let exportAsVCard=Notification.Name("export-as-vCard")
	static let createNewContact=Notification.Name("create-new-contact")
	static let createNewContactFromContact=Notification.Name("create-new-contact-from-contact")
	static let showQRCode=Notification.Name("show-QR-code")
}
