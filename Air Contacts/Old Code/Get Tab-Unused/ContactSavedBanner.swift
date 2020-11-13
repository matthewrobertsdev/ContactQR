//
//  ContactSavedBanner.swift
//  ContactQR
//
//  Created by Matt Roberts on 12/11/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//

import UIKit

class ContactSavedBanner: UIView {

	@IBAction func tapAction(_ sender: Any) {
        tapAction()
    }
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    private var tapAction: (() -> Void)!
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        tapAction = {() -> Void  in
        }
        let bundle=Bundle.main
        let contactNib=UINib(nibName: "ContactSavedBanner", bundle: bundle).instantiate(withOwner: self, options: nil)
        guard let viewFromNib = contactNib.first as? UIView else {
            return
        }
        self.addSubview(viewFromNib)
    }
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }
    public func setTapAction(tapAction:  @escaping () -> Void) {
        self.tapAction=tapAction
    }
}
