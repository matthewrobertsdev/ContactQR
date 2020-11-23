//
//  AppDelegate.swift
//  CardQR
//
//  Created by Matt Roberts on 12/6/18.
//  Copyright © 2018 Matt Roberts. All rights reserved.
//
import UIKit
import WatchConnectivity
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		if WCSession.isSupported() {
			let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        return true
    }
    func applicationWillResignActive(_ application: UIApplication) {
    }
    //save before entering the background
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    //save before ending
    func applicationWillTerminate(_ application: UIApplication) {
    }
}

extension AppDelegate: WCSessionDelegate {

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("Message received: ", message)
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
	}

    func sessionDidDeactivate(_ session: WCSession) {
	}

    func sessionDidBecomeInactive(_ session: WCSession) {
	}
}
