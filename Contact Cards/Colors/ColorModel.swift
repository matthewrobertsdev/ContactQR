//
//  ColorModel.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/24/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import UIKit
class ColorModel {
	let lightString="Light"
	#if os(watchOS)
	let contrastingColor=UIColor.white
	#else
	let contrastingColor=UIColor.label
	#endif
	let colors=[Color(colorChoice: ColorChoice.contrastingColor),
				Color(colorChoice: ColorChoice.gray),
				Color(colorChoice: ColorChoice.red),
				Color(colorChoice: ColorChoice.orange), Color(colorChoice: ColorChoice.yellow),
				Color(colorChoice: ColorChoice.green), Color(colorChoice: ColorChoice.blue),
				Color(colorChoice: ColorChoice.purple), Color(colorChoice: ColorChoice.pink),
				Color(colorChoice: ColorChoice.brown)]
	func getLightColor(colorName: String) -> UIColor? {
		return UIColor(named: lightString+colorName)
	}
}
