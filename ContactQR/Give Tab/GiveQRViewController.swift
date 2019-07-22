//
//  CreateQR_VC.swift
//  ContactExchange
//
//  Created by Matt Roberts on 6/14/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//

import UIKit

class GiveQRViewController: UIViewController, UITableViewDelegate {
    //properties
    @IBOutlet weak var toggleEditButton: UIBarButtonItem!
    @IBAction func toggleEditing(_ sender: Any) {
        controller.toggleEditing()
    }
    @IBOutlet weak var storedContactsTV: UITableView!
    var controller: GiveQRController!
    //methods
    @IBAction func createCodeFromExisting(_ sender: Any) {
        controller.chooseExistingContact()
    }
    @IBAction func createFromExisting(_ sender: Any) {
        controller.createNewContact()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        controller=GiveQRController(createQRViewController: self)
    }
    override func viewWillAppear(_ animated: Bool) {
        storedContactsTV.reloadData()
    }
}
