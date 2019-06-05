//
//  ViewController.swift
//  CardQR
//
//  Created by Matt Roberts on 12/6/18.
//  Copyright © 2018 Matt Roberts. All rights reserved.
//

import UIKit

/*
View controller for displaying the QR code and displaying the view controller PickContactVC
 */

class DisplayQR_VC: UIViewController {
    
    //the controller for this view controller
    private var controller: DisplayQRController!
    
    //displays nothing or the QR code with the String to be scanned
    @IBOutlet weak var qrImageView: UIImageView!

    //displays the info of the current QR code as rows in a table
    @IBOutlet weak var contactInfoTV: UITableView!
    
    //tells controller to display PickContactVC, which uses some of Apple's classes for picking a CNContact to pick (or not pick) a CNContact
    @IBAction func chooseContact(_ sender: Any) {
        controller.chooseContact(vc: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //assigns controller, passing ViewController in so view can be updated from controller
        controller=DisplayQRController(displayQR_VC: self)
       
    }


}

