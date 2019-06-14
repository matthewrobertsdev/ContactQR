//
//  AddContactVC.swift
//  ContactExchange
//
//  Created by Matt Roberts on 6/13/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//

import ContactsUI

class AddContactVC: CNContactViewController, CNContactViewControllerDelegate {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate=self
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
