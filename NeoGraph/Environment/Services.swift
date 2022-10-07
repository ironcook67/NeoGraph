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

	// Todo: Embed CacheManager into DataManager
	var cacheManager: CacheManager { get }
}

class AppServices: Services {
	var calendar: Calendar
	var dateProvider: () -> Date
	var dataManager: DataManager

	// Todo: Embed CacheManager into DataManager
	var cacheManager: CacheManager

	// Todo: Move NeoCache to the DataManager
	var neoCache: Cache<String, [Neo]>

	init(calendar: Calendar = .autoupdatingCurrent,
		 dateProvider: @escaping () -> Date = Date.init,
		 dataManager: DataManager = .init(),
		 cacheManager: CacheManager = .init()) {

		self.calendar = calendar
		self.dateProvider = dateProvider
		self.dataManager = dataManager
		self.cacheManager = cacheManager

		// Entries have a three day life. The server granularity is one full day of
		// Neo data. The times are in UTC, so to cover all of the local time zones
		// the day before and day after in local time is retrieved from the server.
		// If possible, the app will pre-fetch an additional day of data when the current day
		// is about to end. Expire after 4 days.
		// The other defaults are fine.
		self.neoCache = Cache<String, [Neo]>.init(entryLifetime: 4 * 24 * 3600)
	}
}

// Make a global variable until a better way is found.
var appServices = AppServices()
