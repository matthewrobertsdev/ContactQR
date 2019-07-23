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
class DisplayQRViewController: UIViewController {
    //the controller for this view controller
    private var controller: DisplayQRController!
    //displays nothing or the QR code with the String to be scanned
    @IBOutlet weak var qrImageView: UIImageView!
    //displays the info of the current QR code as rows in a table
    @IBOutlet weak var contactInfoTV: UITableView!
    /*
    tells controller to display PickContactVC, which uses some of
    Apple's classes for picking a CNContact to pick (or not pick) a
     CNContact
     */
    var savable=true
    override func viewDidLoad() {
        super.viewDidLoad()
        //assigns controller, passing ViewController in so view can be updated from controller
        controller=DisplayQRController(displayQRViewController: self)
        controller.prepareView()
        let saveSelector=#selector(controller.presentSaveDialog)
        let saveBarButtonItem=UIBarButtonItem(barButtonSystemItem: .save, target: controller, action: saveSelector)
        navigationItem.rightBarButtonItem=saveBarButtonItem
        if !savable {
            disableSave()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        controller.prepareView()
    }
    func disableSave() {
            self.navigationItem.rightBarButtonItem?.isEnabled=false
    }
}
extension Notification.Name {
    //Reference as .contactChanged when type inference is possible
    static let contactAdded=Notification.Name("contact-added")
}
