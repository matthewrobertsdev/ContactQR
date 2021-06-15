//
//  CircularColorView.swift
//  Air Contacts
//
//  Created by Matt Roberts on 11/24/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import UIKit
class CircularColorView: UIView {
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		layer.cornerRadius=frame.width/2
		layer.borderWidth=1
		layer.borderColor=UIColor.systemGray2.cgColor
	}
}
