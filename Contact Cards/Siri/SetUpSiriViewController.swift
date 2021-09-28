//
//  SetUpSiriViewController.swift
//  Contact Cards
//
//  Created by Matt Roberts on 5/26/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import UIKit
import Intents
import IntentsUI
class SetUpSiriViewController: UIViewController {
	@IBOutlet weak var stackView: UIStackView!
	let colorModel=ColorModel()
	var shortCutDelegate: ShortcutDelegate?
	@IBOutlet weak var noCardChosenLabel: UILabel!
	@IBOutlet weak var cardColorCircle: CircularColorView!
	@IBOutlet weak var cardTitleLabel: UILabel!
	override func viewDidLoad() {
        super.viewDidLoad()
		NotificationCenter.default.addObserver(self, selector: #selector(prepareView), name: .siriCardChosen, object: nil)
		let shortCutButton=INUIAddVoiceShortcutButton(style: .automatic)
		stackView.insertArrangedSubview(shortCutButton, at: 3)
		shortCutDelegate=ShortcutDelegate(viewController: self)
		guard let shortCutDelegate=shortCutDelegate else {
			return
		}
		//size width of shortCut button
		shortCutButton.translatesAutoresizingMaskIntoConstraints=false
		NSLayoutConstraint.activate([
			shortCutButton.widthAnchor.constraint(equalToConstant: 250)
		])
		shortCutButton.delegate=shortCutDelegate
		let intent=ShowCardIntent()
		intent.suggestedInvocationPhrase = "Show Card"
		let interaction = INInteraction(intent: intent, response: nil)
				interaction.donate { (error) in
					if let error = error {
						print("\n Error: \(error.localizedDescription))")
					} else {
						print("\n Donated ShowCardItent")
					}
				}
		shortCutButton.shortcut=INShortcut(intent: intent)
        // Do any additional setup after loading the view.
    }
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		prepareView()
	}
	@objc func prepareView() {
		if UserDefaults(suiteName: appGroupKey)?.object(forKey: SiriCardKeys.chosenCardObjectID.rawValue) as? String != nil {
			noCardChosenLabel.text="Chosen Card:"
			if let colorString=UserDefaults(suiteName: appGroupKey)?.object(forKey: SiriCardKeys.chosenCardColor.rawValue) as? String {
				let color=UIColor(named: "Dark"+colorString) ?? UIColor.label
				cardColorCircle.isHidden=false
				cardColorCircle.backgroundColor=color
			}
			if let cardTitle=UserDefaults(suiteName: appGroupKey)?.object(forKey: SiriCardKeys.chosenCardTitle.rawValue) as? String {
				cardTitleLabel.isHidden=false
				cardTitleLabel.text=cardTitle
			}
		} else {
			noCardChosenLabel.text="No Card Chosen"
			cardTitleLabel.isHidden=true
			cardColorCircle.isHidden=true
		}
	}
	@IBAction func removeCard(_ sender: Any) {
		updateSiriCard(contactCard: nil)
		prepareView()
	}
	@IBAction func done(_ sender: Any) {
		dismiss(animated: true)
	}
}
