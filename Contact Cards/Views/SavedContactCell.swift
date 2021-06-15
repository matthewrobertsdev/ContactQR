//
//  SavedContactTVCell.swift
//  Contact Cards
//
//  Created by Matt Roberts on 6/14/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//
import UIKit
class SavedContactCell: UITableViewCell {
	@IBOutlet weak var circularColorView: CircularColorView!
	@IBOutlet weak var nameLabel: UILabel!
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}
}
