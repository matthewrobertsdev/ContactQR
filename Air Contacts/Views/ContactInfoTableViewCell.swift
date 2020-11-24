//
//  ContactInfoTableViewCell.swift
//  Air Contacts
//
//  Created by Matt Roberts on 11/19/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import UIKit
class ContactInfoTableViewCell: UITableViewCell {
	@IBOutlet weak var infoLabel: UILabel!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
