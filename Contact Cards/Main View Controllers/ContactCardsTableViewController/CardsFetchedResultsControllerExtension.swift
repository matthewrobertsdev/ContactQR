//
//  CardsFetchedResultsControllerExtension.swift
//  Contact Cards
//
//  Created by Matt Roberts on 7/14/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import UIKit
import CoreData
// MARK: FRC Delegate
extension ContactCardsTableViewController: NSFetchedResultsControllerDelegate {
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		//disable animations for catalyst--UITableView animations are buggy
		#if targetEnvironment(macCatalyst)
		UIView.setAnimationsEnabled(false)
		#endif
		self.tableView.beginUpdates()
	}
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		self.tableView.endUpdates()
		do {
			try (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext.save()
		} catch {
			print("Error saving iCloud changes")
		}
		if let fetchedResultsController=fetchedResultsController {
			updateCards(fetchedResultsController: fetchedResultsController)
		}
		handleSelection()
		UserDefaults(suiteName: appGroupKey)?.setValue(UUID().uuidString, forKey: "lastUpdateUUID")
		//reanable animations if disabled for catalyst
		#if targetEnvironment(macCatalyst)
		UIView.setAnimationsEnabled(true)
		#endif
	}
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
					didChange anObject: Any,
					at indexPath: IndexPath?,
					for type: NSFetchedResultsChangeType,
					newIndexPath: IndexPath?) {
		var animation=UITableView.RowAnimation.fade
		#if targetEnvironment(macCatalyst)
		animation=UITableView.RowAnimation.none
		#endif
		switch type {
		case .insert:
			if let newIndexPath=newIndexPath {
				self.tableView.insertRows(at: [newIndexPath], with: animation)
			}
		case .delete:
			if let indexPath=indexPath {
				self.tableView.deleteRows(at: [indexPath], with: animation)
			}
		case .update:
			if let indexPath=indexPath {
				tableView.reloadRows(at: [indexPath], with: animation)
			}
		case .move:
			if let indexPath=indexPath {
				self.tableView.deleteRows(at: [indexPath], with: animation)
			}
			if let newIndexPath=newIndexPath {
				self.tableView.insertRows(at: [newIndexPath], with: animation)
			}
		default:
			break
		}
	}
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
					didChange sectionInfo: NSFetchedResultsSectionInfo,
					atSectionIndex sectionIndex: Int,
					for type: NSFetchedResultsChangeType) {
		let sectionIndexSet = NSIndexSet(index: sectionIndex) as IndexSet
		var animation=UITableView.RowAnimation.fade
		#if targetEnvironment(macCatalyst)
		animation=UITableView.RowAnimation.none
		#endif
		switch type {
		case .insert:
			self.tableView.insertSections(sectionIndexSet, with: animation)
		case .delete:
			self.tableView.deleteSections(sectionIndexSet, with: animation)
		default:
			break
		}
	}
}
