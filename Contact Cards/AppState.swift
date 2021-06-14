//
//  AppState.swift
//  Contact Cards
//
//  Created by Matt Roberts on 11/25/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//
import Foundation
enum AppStateValue {
	case isNotModal
	case isModal
}
class AppState {
	static let shared=AppState()
	private init() {
	}
	var appState=AppStateValue.isNotModal
}
