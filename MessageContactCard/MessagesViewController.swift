//
//  MessagesViewController.swift
//  MessageContactCard
//
//  Created by Matt Roberts on 4/2/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//

import UIKit
import Messages
import CoreData
import Contacts
class MessagesViewController: MSMessagesAppViewController, UITableViewDataSource,
							  UITableViewDelegate, NSFilePresenter {
	var presentedItemURL: URL?
	var presentedItemOperationQueue=OperationQueue.main
	var userDefaults: UserDefaults?
	@IBOutlet weak var tableView: UITableView!
	var contactCards=[ContactCardMO]()
	let colorModel=ColorModel()
	lazy var persistentContainer: NSPersistentCloudKitContainer = loadPersistentContainer()
	func presentedItemDidChange() {
		prepareView()
	}
	//var errorString=""
	override func viewDidLoad() {
        super.viewDidLoad()
		tableView.dataSource=self
		tableView.delegate=self
		NSFileCoordinator.addFilePresenter(self)
		userDefaults=UserDefaults(suiteName: "group.com.apps.celeritas.contact.cards")
		userDefaults?.addObserver(self, forKeyPath: "lastUpdateUUID", options: [.new, .initial], context: nil)
		/*
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
			//self.errorString=error?.localizedDescription ?? ""
		}
*/
		//prepareView()
		//NotificationCenter.default.addObserver(self, selector: #selector((reloadView)), name: .NSPersistentStoreRemoteChange, object: nil)
        // Do any additional setup after loading the view.
    }
	override func viewWillAppear(_ animated: Bool) {
		prepareView()
	}
	@IBAction func syncWithApp(_ sender: Any) {
		prepareView()
	}
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		print("value observed")
		prepareView()
	}
	@objc func prepareView() {
		let managedObjectContext=persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<ContactCardMO>(entityName: ContactCardMO.entityName)
			do {
				// Execute Fetch Request
				contactCards = try managedObjectContext.fetch(fetchRequest)
				contactCards.sort { firstCard, secondCard in
					return firstCard.filename<secondCard.filename
				}
			} catch {
				print("Unable to fetch contact cards")
				//errorString=error.localizedDescription
			}
		print("Bye")
			tableView.reloadData()
	}
    // MARK: - Conversation Handling
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        // Use this method to configure the extension and restore previously stored state.
    }
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dismisses the extension, changes to a different
        // conversation or quits Messages.
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        // Use this method to trigger UI updates in response to the message.
    }
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
        // Use this to clean up state related to the deleted message.
    }
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
        // Use this method to prepare for the change in presentation style.
    }
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
        // Use this method to finalize any behaviors associated with the change in presentation style.
    }
	// MARK: - Table view data source
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return contactCards.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		/*
		let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
				cell.textLabel?.text = errorString
				return cell
		*/
		guard let cell=tableView.dequeueReusableCell(withIdentifier: "SavedContactCell", for: indexPath)
				as? SavedContactCell else {
			return UITableViewCell()
		}
		do {
		if let contactCard = try persistentContainer.viewContext.existingObject(with: contactCards[indexPath.row].objectID) as? ContactCardMO {
		cell.nameLabel.text=contactCard.filename
		let colorString=contactCard.color
			if let color=colorModel.getColorsDictionary()[colorString] as? UIColor {
			cell.circularColorView.backgroundColor=color
		}
		}
		} catch {
			print("error loading ContactCardMO from viewContext")
		}
		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		do {
			guard let contactCard = try persistentContainer.viewContext.existingObject(with: contactCards[indexPath.row].objectID) as? ContactCardMO else {
				return
			}
			guard let directoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
					return
				}
			guard let url=ContactDataConverter.writeTemporaryFile(contactCard: contactCard, directoryURL: directoryURL) else {
				return
			}
			self.activeConversation?.insertAttachment(url, withAlternateFilename: nil)
		} catch {
			print("error loading ContactCardMO from viewContext")
		}
	}
}
extension UserDefaults
{
	@objc dynamic var date: String?
	{
		get {
			return string(forKey: "date")
		}
		set {
			set(newValue, forKey: "date")
		}
	}
}
