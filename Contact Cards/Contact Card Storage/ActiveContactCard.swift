//
//  ActiveContact.swift
//  CardQR
//
//  Created by Matt Roberts on 6/4/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//
import Foundation
import Contacts
/*
 Singleton for holding the active contact (the one to
 be used thgroughout the app).  See below for extension of
 Notification.Name, .contactChanged, for notifications
 about when activeContact changes
 */
class ActiveContactCard {
    //shared is the singleton
    static let shared=ActiveContactCard()
    //stoes a CNContact for use throughout the app
    var contactCard: ContactCard?
    private init() {
    }
}
/*
 Post this WHENEVER ActiveContact.shared.activeContact changes
 */
extension Notification.Name {
    //Reference as .contactChanged when type inference is possible
    static let contactChanged=Notification.Name("contact-changed")
}
