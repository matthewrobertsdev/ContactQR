//
//  Color.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/24/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import UIKit
struct Color {
	var name=ColorChoice.contrastingColor.rawValue
	var color=UIColor.white
	init(colorChoice: ColorChoice) {
		name=colorChoice.rawValue
		if colorChoice==ColorChoice.contrastingColor {
			#if os(watchOS)
			color=UIColor.white
			#else
			color=UIColor.label
			#endif
		} else {
			color=UIColor(named: "Dark"+colorChoice.rawValue) ?? UIColor.white
		}
	}
}
