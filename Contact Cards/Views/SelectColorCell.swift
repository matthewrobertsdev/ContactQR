//
//  SelectColorCell.swift
//  Contact Cards
//
//  Created by Matt Roberts on 9/26/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import UIKit
class SelectColorCell: UICollectionViewCell {
	@IBOutlet weak var circularColorView: CircularColorView!
	@IBOutlet weak var selectionView: BorderlessColorView!
	override var isSelected: Bool {
		willSet {
			if newValue {
				selectionView.isHidden=false
			} else {
				selectionView.isHidden=true
			}
		}
	}
}
