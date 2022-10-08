//
//  Services.swift
//  NeoGraph
//
//  Created by Chon Torres on 10/2/22.
//

import SwiftUI

protocol Services: ObservableObject {
	var calendar: Calendar { get }
	var dateProvider: () -> Date { get }
	var dataManager: DataManager { get }
	var apiKey: String { get }
}

class AppServices: Services {
	var calendar: Calendar
	var dateProvider: () -> Date
	var dataManager: DataManager
	@AppStorage(AppStorageKeys.apiKey.rawValue) var apiKey = NASAURLBuilder.DEMO_KEY

	init(calendar: Calendar = .autoupdatingCurrent,
		 dateProvider: @escaping () -> Date = Date.init,
		 dataManager: DataManager = .init()) {

		self.calendar = calendar
		self.dateProvider = dateProvider
		self.dataManager = dataManager
	}
}

// Make a global variable until a better way is found.
// Todo: Change this before releasing
var appServices = AppServices()
