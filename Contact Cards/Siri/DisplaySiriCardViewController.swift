//
//  DisplaySiriCardViewController.swift
//  Contact Cards
//
//  Created by Matt Roberts on 5/28/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import UIKit
class DisplaySiriCardViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
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
	@IBAction func done(_ sender: Any) {
		dismiss(animated: true)
	}
}
