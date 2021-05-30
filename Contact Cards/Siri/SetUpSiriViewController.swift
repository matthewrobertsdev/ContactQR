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
						print("\n Donated CreateExpenseIntent")
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
		if let _=UserDefaults(suiteName: "group.com.apps.celeritas.contact.cards")?.object(forKey: "chosenCardObjectID") as? String {
			noCardChosenLabel.text="Chosen Card:"
			if let colorString=UserDefaults(suiteName: "group.com.apps.celeritas.contact.cards")?.object(forKey: "chosenCardColor") as? String {
			let color=(colorModel.getColorsDictionary()[colorString] ?? UIColor.label) ?? UIColor.label
				cardColorCircle.isHidden=false
				cardColorCircle.backgroundColor=color
			}
			if let cardTitle=UserDefaults(suiteName: "group.com.apps.celeritas.contact.cards")?.object(forKey: "chosenCardTitle") as? String {
				cardTitleLabel.isHidden=false
				cardTitleLabel.text=cardTitle
			}
		} else {
			noCardChosenLabel.text="No Card Chosen"
			cardTitleLabel.isHidden=true
			cardColorCircle.isHidden=true
		}
	}
	@IBAction func done(_ sender: Any) {
		dismiss(animated: true)
	}
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
