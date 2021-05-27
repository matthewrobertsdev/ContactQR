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
	var shortCutDelegate: ShortcutDelegate?
	override func viewDidLoad() {
        super.viewDidLoad()
		let shortCutButton=INUIAddVoiceShortcutButton(style: .automatic)
		stackView.addArrangedSubview(shortCutButton)
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
		intent.suggestedInvocationPhrase = "Show card."
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
