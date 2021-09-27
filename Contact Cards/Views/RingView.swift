//
//  RingView.swift
//  Contact Cards
//
//  Created by Matt Roberts on 9/26/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import UIKit
import CoreGraphics
class RingView: UIView {
	override class var layerClass: AnyClass {
		return CAShapeLayer.self
	}
	override func layoutSubviews() {
		super.layoutSubviews()
		if let layer = self.layer as? CAShapeLayer {
			layer.strokeColor = UIColor.label.cgColor
			layer.fillColor = nil
			layer.lineWidth = 6
			let margin=CGFloat(4)
			layer.path = CGPath(ellipseIn: bounds.inset(by: UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)), transform: nil)
		}
	}
}
