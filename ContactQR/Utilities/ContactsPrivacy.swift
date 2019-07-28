//
//  ContactPrivacy.swift
//  ContactQR
//
//  Created by Matt Roberts on 7/28/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//
import UIKit
import Contacts
class ContactsPrivacy: Privacy {
    static func contactsCheck(viewController: UIViewController, appName: String) -> Bool {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        //if authorization is not determined, request it
        case .notDetermined:
            var authorized=false
            let cnContactStore=CNContactStore()
            cnContactStore.requestAccess(for: .contacts) { (granted, _ ) in
                authorized=granted
            }
            return authorized
        //if authorization is restricted, request that the user goes to privacy settings
        case .restricted:
            showContactPrivacyAlert(fromViewController: viewController, appName: appName)
            return false
        //if authorization is denied, request that the user goes to privacy settings
        case .denied:
            showContactPrivacyAlert(fromViewController: viewController, appName: appName)
            return false
        //if authorization is authorized and camera is available, return true so that the tab can be shwon
        case .authorized:
            //so qr code scanner can be shown
            return true
        @unknown default:
            return false
        }
    }
    static func showContactPrivacyAlert(fromViewController: UIViewController, appName: String) {
        DispatchQueue.main.async {
            let permissionString=" doesn't have permission to access your Contacts.  Please change privacy settings."
            let changePrivacySetting = appName+permissionString
            let comment="Alert message when the user has denied access to Contacts."
            let message = NSLocalizedString(changePrivacySetting, comment: comment)
            let privacyAlert=Privacy.createPrivacyAlert(message: message, appName: appName)
            fromViewController.present(privacyAlert, animated: true, completion: nil)
        }
    }

}
