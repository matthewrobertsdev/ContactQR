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
        
    }
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    private var tapActionCallable: Callable!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        tapActionCallable=StubCallable()
        let viewFromNib = UINib(nibName: "SaveContactBanner", bundle: Bundle.main).instantiate(withOwner: self, options: nil).first as? UIView
        self.addSubview(viewFromNib!);
    }
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }

    public func setTapActionCallable(tapActionCallable: Callable){
        self.tapActionCallable=tapActionCallable
    }

}
