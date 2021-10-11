//
//  IntentViewController.swift
//  ShowMyCardSirirUI
//
//  Created by Matt Roberts on 5/26/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import IntentsUI
// As an example, this extension's Info.plist has been configured to handle interactions for INSendMessageIntent.
// You will want to replace this or add other intents as appropriate.
// The intents whose interactions you wish to handle must be declared in the extension's Info.plist.
// You can test this example integration by saying things to Siri like:
class IntentViewController: UIViewController, INUIHostedViewControlling {
	@IBOutlet weak var cardNootChosenView: UIView!
	@IBOutlet weak var imageView: UIImageView!
	let colorModel=ColorModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		if let qrImageData=UserDefaults(suiteName: "group.com.apps.celeritas.contact.cards")?.data(forKey: SiriCardKeys.chosenCardImageData.rawValue) {
			cardNootChosenView.isHidden=true
			if let colorString=UserDefaults(suiteName: "group.com.apps.celeritas.contact.cards")?.string(forKey: SiriCardKeys.chosenCardColor.rawValue) {
				let color=UIColor(named: colorString) ?? UIColor.label
				if var qrImage=UIImage(data: qrImageData) {
					qrImage=qrImage.withTintColor(color)
					imageView.image=qrImage
					if let cardTitle=UserDefaults(suiteName: "group.com.apps.celeritas.contact.cards")?.string(forKey: SiriCardKeys.chosenCardTitle.rawValue) {
						imageView.accessibilityLabel=cardTitle+" QR Code"
						imageView.accessibilityValue="image"
					}
				} else {
					imageView.accessibilityLabel="Error making QR code."
				}
			}
		} else {
			cardNootChosenView.isHidden=false
		}
    }
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
	}
	// MARK: - INUIHostedViewControlling
    // Prepare your view controller for the interaction to handle.
    func configureView(for parameters: Set<INParameter>, of interaction: INInteraction, interactiveBehavior: INUIInteractiveBehavior,
					   context: INUIHostedViewContext, completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void) {
        // Do configuration here, including preparing views and calculating a desired size for presentation.
        completion(true, parameters, self.desiredSize)
    }
    var desiredSize: CGSize {
		#if targetEnvironment(macCatalyst)
		return CGSize(width: 500, height: 500)
		#else
		let screenSize=UIScreen.main.bounds
		var smaller: CGFloat
		var greater: CGFloat
		if screenSize.width<screenSize.height {
			greater=screenSize.height
		} else {
			greater=screenSize.width
		}
		smaller=greater*(9/20)
		if 340<smaller {
			smaller=340
		}
		return CGSize(width: 300, height: smaller)
		#endif
	}
}
