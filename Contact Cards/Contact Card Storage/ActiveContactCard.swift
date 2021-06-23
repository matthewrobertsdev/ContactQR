//
//  ActiveContact.swift
//  Contact Cards
//
//  Created by Matt Roberts on 6/4/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//
import Foundation
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
    var contactCard: ContactCardMO?
    private init() {
    }
}
