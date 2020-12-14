//
//  ColorModel.swift
//  Air Contacts
//
//  Created by Matt Roberts on 11/24/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import UIKit
class ColorModel {
	let colors=[Color(colorChoice: ColorChoice.contrastingColor),
				Color(colorChoice: ColorChoice.gray),
				Color(colorChoice: ColorChoice.red),
				Color(colorChoice: ColorChoice.orange), Color(colorChoice: ColorChoice.yellow),
				Color(colorChoice: ColorChoice.green), Color(colorChoice: ColorChoice.blue),
				Color(colorChoice: ColorChoice.purple), Color(colorChoice: ColorChoice.pink),
				Color(colorChoice: ColorChoice.brown)]
	let colorsDictionary=[ColorChoice.contrastingColor.rawValue: UIColor.label,
						  ColorChoice.gray.rawValue: UIColor(named: ColorChoice.gray.rawValue),
						  ColorChoice.red.rawValue: UIColor(named: ColorChoice.red.rawValue),
						  ColorChoice.orange.rawValue: UIColor(named: ColorChoice.orange.rawValue),
						  ColorChoice.yellow.rawValue: UIColor(named: ColorChoice.yellow.rawValue),
						  ColorChoice.green.rawValue: UIColor(named: ColorChoice.green.rawValue),
						  ColorChoice.blue.rawValue: UIColor(named: ColorChoice.blue.rawValue),
						  ColorChoice.purple.rawValue: UIColor(named: ColorChoice.purple.rawValue),
						  ColorChoice.pink.rawValue: UIColor(named: ColorChoice.pink.rawValue),
						  ColorChoice.brown.rawValue: UIColor(named: ColorChoice.brown.rawValue)]
}
