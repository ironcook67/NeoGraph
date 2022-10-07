//
//  Services.swift
//  NeoGraph
//
//  Created by Chon Torres on 10/2/22.
//

import Foundation

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
	var apiKey: String

	init(calendar: Calendar = .autoupdatingCurrent,
		 dateProvider: @escaping () -> Date = Date.init,
		 dataManager: DataManager = .init(),
		 apiKey: String = "DEMO_KEY") {

		self.calendar = calendar
		self.dateProvider = dateProvider
		self.dataManager = dataManager
		self.apiKey = apiKey
	}
}

// Make a global variable until a better way is found.
// Todo: Change this before releasing
var appServices = AppServices(apiKey: "VP6e3MHCihUzVpKioZFfKe3wHoJjhYeandyKMr0m")
