//
//  SavedContactTVCell.swift
//  ContactExchange
//
//  Created by Matt Roberts on 6/14/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//

import UIKit

//A very simple tv cell--for formatting in interface builder
class SavedContactCell: UITableViewCell {
    //name of file for contact
	@IBOutlet weak var circularColorView: CircularColorView!
	@IBOutlet weak var nameLabel: UILabel!
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}
}
