//
//  SetUpSiriViewController.swift
//  Contact Cards
//
//  Created by Matt Roberts on 5/26/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//

import UIKit
import Intents
class SetUpSiriViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		let intent=ShowCardIntent()
		intent.suggestedInvocationPhrase = "Show contact card."
		let interaction = INInteraction(intent: intent, response: nil)
				interaction.donate { (error) in
					if let error = error {
						print("\n Error: \(error.localizedDescription))")
					} else {
						print("\n Donated CreateExpenseIntent")
					}
				}
        // Do any additional setup after loading the view.
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
