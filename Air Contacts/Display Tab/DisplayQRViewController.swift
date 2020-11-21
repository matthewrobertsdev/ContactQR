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
	@IBOutlet weak var contactCardTitleLabel: UILabel!
	let model=DisplayQRModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
	func prepareView() {
		qrImageView.image=getTintedForeground(image: model.makeQRCode(), color:UIColor.systemGreen)
		contactCardTitleLabel.text=model.getContactCardTitle()
	}
	@IBAction func done(_ sender: Any) {
		dismiss(animated: true)
	}
}
