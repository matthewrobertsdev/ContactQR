//
//  SaveContactBannerView.swift
//  CardQR
//
//  Created by Matt Roberts on 6/6/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//
import UIKit
class SaveContactBanner: UIView {
    @IBAction func tapAction(_ sender: Any) {
        tapActionCallable.call()
    }
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    private var tapActionCallable: Callable!
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        tapActionCallable=StubCallable()
        let bundle=Bundle.main
        let contactNib=UINib(nibName: "SaveContactBanner", bundle: bundle).instantiate(withOwner: self, options: nil)
        guard let viewFromNib = contactNib.first as? UIView else {
            return
        }
        self.addSubview(viewFromNib)
    }
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }
    public func setTapActionCallable(tapActionCallable: Callable) {
        self.tapActionCallable=tapActionCallable
    }
}