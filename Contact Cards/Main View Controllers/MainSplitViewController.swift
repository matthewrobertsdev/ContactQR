//
//  MainSplitViewController.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/11/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import UIKit
//MARK: MainSplitViewController
class MainSplitViewController: UISplitViewController, UISplitViewControllerDelegate {
	override func viewDidLoad() {
		super.viewDidLoad()
		self.delegate = self
		self.preferredDisplayMode = .oneBesideSecondary
		NSUbiquitousKeyValueStore.default.synchronize()
	}
	func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary
							secondaryViewController: UIViewController,
							onto primaryViewController: UIViewController) -> Bool {
		return false
	}
	func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn
								proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
		return .primary
	}
}
