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
	}
	@objc func exportAsVCard() {
		NotificationCenter.default.post(name: .exportAsVCard, object: self)
	}
	override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
		guard let splitViewController = self.window?.rootViewController as? UISplitViewController else {
			return false
		}
		if action==#selector(exportAsVCard) {
			guard let contactCardViewController=splitViewController.viewController(for: .secondary) as? ContactCardViewController else {
				return false
			}
			guard let _=contactCardViewController.contactCard else {
				return false
			}
			return true
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
}
extension Notification.Name {
	static let exportAsVCard=Notification.Name("export-as-vCard")
}
