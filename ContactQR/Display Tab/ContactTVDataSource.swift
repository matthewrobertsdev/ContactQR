//
//  ContactTVDataSource.swift
//  CardQR
//
//  Created by Matt Roberts on 12/25/18.
//  Copyright © 2018 Matt Roberts. All rights reserved.
//

import UIKit
import Contacts

/*
 Data source for the display QR view controller's table view
 */
class ContactTVDataSource: NSObject, UITableViewDataSource{
    
    //an array of pairs of Strings for the data source
    private var contactInfoArray: [(String, String)]=[]
    
    //called by other objects to update the array
    func updateModel(contactInfoArray: [(String, String)]){
        self.contactInfoArray=contactInfoArray
    }
    
    //get coiunt for data source from array's count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactInfoArray.count
    }
    
    //return a cell from the array and an index
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "ContactInfoTVCell")
        cell?.textLabel?.text=contactInfoArray[indexPath.row].0
        cell?.detailTextLabel?.text=contactInfoArray[indexPath.row].1
        
        return cell!
    }
}
