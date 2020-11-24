//
//  MainSplitViewController.swift
//  Air Contacts
//
//  Created by Matt Roberts on 11/11/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import UIKit
class MainSplitViewController: UISplitViewController, UISplitViewControllerDelegate {
	override func viewDidLoad() {
		super.viewDidLoad()
		self.delegate = self
		self.preferredDisplayMode = .oneBesideSecondary
	}
	func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary
							secondaryViewController: UIViewController,
							 onto primaryViewController: UIViewController) -> Bool {
	return false
	}
	@available(iOS 14.0, *)
	func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn
								proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
		return .primary
	}
}
