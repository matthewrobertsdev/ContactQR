//
//  Color.swift
//  Air Contacts
//
//  Created by Matt Roberts on 11/24/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import UIKit
struct Color {
	var name=ColorChoice.contrastingColor.rawValue
	var color=UIColor.label
	init(colorChoice: ColorChoice) {
		name=colorChoice.rawValue
		if colorChoice==ColorChoice.contrastingColor {
			color=UIColor.label
		} else {
			color=UIColor(named: colorChoice.rawValue) ?? UIColor.label
		}
	}
}
