//
//  CardsKeyCommandsExtension.swift
//  Contact Cards
//
//  Created by Matt Roberts on 7/14/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//

import UIKit
// MARK: Key Coomands
extension ContactCardsTableViewController {
	override var keyCommands: [UIKeyCommand]? {
		if AppState.shared.appState==AppStateValue.isModal {
			return nil
		}
		let keyCommands=[
			UIKeyCommand(title: "Previous Contact", image: nil, action: #selector(goUpOne),
						 input: UIKeyCommand.inputUpArrow, modifierFlags:
							.command, propertyList: nil, alternates: [], discoverabilityTitle: "Previous Contact",
						 attributes: [], state: .on),
			UIKeyCommand(title: "Next Contact", image: nil, action: #selector(goDownOne), input: UIKeyCommand.inputDownArrow,
						 modifierFlags: .command, propertyList: nil, alternates: [], discoverabilityTitle: "Next Contact",
						 attributes: [], state: .on)
		]
		return keyCommands
	}
}

