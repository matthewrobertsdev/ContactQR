//
//  AppState.swift
//  Air Contacts
//
//  Created by Matt Roberts on 11/25/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import Foundation
enum AppStateValue: String {
	case isNotModal
	case isModal
}
class AppState{
	static let shared=AppState()
	private init() {
	}
	var appState=AppStateValue.isNotModal
}
