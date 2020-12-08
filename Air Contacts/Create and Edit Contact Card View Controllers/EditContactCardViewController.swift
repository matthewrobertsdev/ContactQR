//
//  EditContactCardViewController.swift
//  Air Contacts
//
//  Created by Matt Roberts on 12/7/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//

import UIKit

class EditContactCardViewController: UIViewController {
	@IBOutlet weak var editButton: UIButton!
	@IBOutlet weak var changeColorButton: UIButton!
	@IBOutlet weak var changeTitleButton: UIButton!
	override func viewDidLoad() {
        super.viewDidLoad()
		editButton.sizeToFit()
		changeColorButton.sizeToFit()
		changeTitleButton.sizeToFit()
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
	override var canBecomeFirstResponder: Bool {
		return true
	}
	@IBAction func cancel(_ sender: Any) {
		navigationController?.dismiss(animated: true)
	}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
	override var keyCommands: [UIKeyCommand]? {
		return [UIKeyCommand(title: "Close", image: nil, action: #selector(cancel(_:)), input: UIKeyCommand.inputEscape,
							 modifierFlags: .command, propertyList: nil, alternates: [], discoverabilityTitle: "Close",
							 attributes: .destructive, state: .on)]
	}
}
