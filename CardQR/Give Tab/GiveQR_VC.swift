//
//  CreateQR_VC.swift
//  ContactExchange
//
//  Created by Matt Roberts on 6/14/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//

import UIKit

class GiveQR_VC: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var toggleEditButton: UIBarButtonItem!
    
    @IBAction func toggleEditing(_ sender: Any) {
        controller.toggleEditing()
    }
    
    @IBOutlet weak var storedContactsTV: UITableView!
    
    var controller: GiveQRController!

    @IBAction func createCodeFromExisting(_ sender: Any) {
        controller.chooseExistingContact()
    }
    
    
    @IBAction func createFromExisting(_ sender: Any) {
        controller.createNewContact()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controller=GiveQRController(createQR_VC: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        storedContactsTV.reloadData()
    }

}
