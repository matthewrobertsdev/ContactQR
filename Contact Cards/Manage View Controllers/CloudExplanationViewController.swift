//
//  iCloudExplanationViewController.swift
//  Contact Cards
//
//  Created by Matt Roberts on 7/17/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import UIKit
class CloudExplanationViewController: UIViewController {
	@IBOutlet weak var explanationLabel: UILabel!
	override func viewDidLoad() {
        super.viewDidLoad()
		explanationLabel.text=iCloudExplanationString()+"by using the back button and following the steps described on the manage contact cards interface."
		explanationLabel.sizeToFit()
        // Do any additional setup after loading the view.
    }
}
