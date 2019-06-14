//
//  CreateQR_VC.swift
//  ContactExchange
//
//  Created by Matt Roberts on 6/14/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//

import UIKit

class CreateQR_VC: UIViewController {
    
    var controller: CreateQRController!

    
    @IBAction func createCodeFromExisting(_ sender: Any) {
        controller.chooseExistingContact()
    }
    
    
    @IBAction func createFromExisting(_ sender: Any) {
        controller.createNewContact()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controller=CreateQRController(createQR_VC: self)
        
    }
    

    

}
