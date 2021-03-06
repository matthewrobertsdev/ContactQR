//
//  ExportContactCardViewController.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/25/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import UIKit
class SaveDocumentViewController: UIDocumentPickerViewController, UIDocumentPickerDelegate {
	var url: URL?
    override func viewDidLoad() {
        super.viewDidLoad()
		delegate=self
        // Do any additional setup after loading the view.
    }
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		AppState.shared.appState=AppStateValue.isModal
		NotificationCenter.default.post(name: .modalityChanged, object: nil)
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		AppState.shared.appState=AppStateValue.isNotModal
		NotificationCenter.default.post(name: .modalityChanged, object: nil)
	}
	func documentPicker(_ controller: UIDocumentPickerViewController,
						didPickDocumentsAt urls: [URL]) {
		guard let url=url else {
			return
		}
		let fileManager=FileManager.default
		try? fileManager.removeItem(at: url)
		dismiss(animated: true)
	}
}
