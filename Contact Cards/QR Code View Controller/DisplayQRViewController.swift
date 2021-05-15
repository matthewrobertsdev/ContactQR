//
//  ViewController.swift
//  CardQR
//
//  Created by Matt Roberts on 12/6/18.
//  Copyright © 2018 Matt Roberts. All rights reserved.
//
import UIKit
class DisplayQRViewController: UIViewController {
    @IBOutlet weak var qrImageView: UIImageView!
	@IBOutlet weak var errorLabel: UILabel!
	let model=DisplayQRModel()
	let colorModel=ColorModel()
	let colorString=ColorChoice.contrastingColor.rawValue
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		AppState.shared.appState=AppStateValue.isModal
		NotificationCenter.default.post(name: .modalityChanged, object: nil)
		prepareView()
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		AppState.shared.appState=AppStateValue.isNotModal
		NotificationCenter.default.post(name: .modalityChanged, object: nil)
	}
	override var canBecomeFirstResponder: Bool {
		return true
	}
	func prepareView() {
		model.setUp(contactCard: ActiveContactCard.shared.contactCard)
		let color=colorModel.getColorsDictionary()[ActiveContactCard.shared.contactCard?.color ??
												"Contasting Color"] ?? UIColor.label
		print(ActiveContactCard.shared.contactCard?.color ?? "default")
		if let qrCode=model.makeQRCode() {
			qrImageView.image=getTintedForeground(image: qrCode, color: color ?? UIColor.label)
		} else {
			errorLabel.isHidden=false
		}
	}
	@IBAction func done(_ sender: Any) {
		dismiss(animated: true)
	}
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
			super.traitCollectionDidChange(previousTraitCollection)
			prepareView()
		}
	override var keyCommands: [UIKeyCommand]? {
		return [UIKeyCommand(title: "Close", image: nil, action: #selector(done(_:)), input: UIKeyCommand.inputEscape,
							 modifierFlags: .command, propertyList: nil, alternates: [], discoverabilityTitle: "Close",
							 attributes: .destructive, state: .on)]
	}
}
