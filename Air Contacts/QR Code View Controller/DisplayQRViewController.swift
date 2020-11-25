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
	let colorModel=ColorModel()
	let colorString=ColorChoice.contrastingColor.rawValue
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
	func prepareView() {
		let color=colorModel.colorsDictionary[ActiveContactCard.shared.contactCard?.color ??
												"Contasting Color"] ?? UIColor.label
		print(ActiveContactCard.shared.contactCard?.color ?? "default")
		qrImageView.image=getTintedForeground(image: model.makeQRCode(), color: color ?? UIColor.label)
		contactCardTitleLabel.text=model.getContactCardTitle()
		contactCardTitleLabel.textColor=color
	}
	@IBAction func done(_ sender: Any) {
		dismiss(animated: true)
	}
}
