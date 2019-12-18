//
//  InterfaceController.swift
//  wtach-toss Extension
//
//  Created by Matt Roberts on 12/18/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class MainInterfaceController: WKInterfaceController, WCSessionDelegate {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
	}

}

