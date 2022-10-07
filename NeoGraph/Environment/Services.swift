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
}

class AppServices: Services {
	var calendar: Calendar
	var dateProvider: () -> Date
	var dataManager: DataManager

	init(calendar: Calendar = .autoupdatingCurrent,
		 dateProvider: @escaping () -> Date = Date.init,
		 dataManager: DataManager = .init()) {

		self.calendar = calendar
		self.dateProvider = dateProvider
		self.dataManager = dataManager
	}
}

// Make a global variable until a better way is found.
var appServices = AppServices()
