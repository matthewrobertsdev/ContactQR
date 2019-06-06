//
//  SaveContactBannerView.swift
//  CardQR
//
//  Created by Matt Roberts on 6/6/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//

import UIKit

class SaveContactBanner: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        let viewFromNib = UINib(nibName: "SaveContactBanner", bundle: Bundle.main).instantiate(withOwner: self, options: nil).first as? UIView
        self.addSubview(viewFromNib!);
    }
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }


}
