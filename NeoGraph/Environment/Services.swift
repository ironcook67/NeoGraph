//
//  Services.swift
//  NeoGraph
//
//  Created by Chon Torres on 10/2/22.
//

import Foundation

protocol Services: ObservableObject {
	var calendar: Calendar { get }
	var dataManager: DataManager { get }
	var cacheManager: CacheManager { get }
}

class AppServices: Services {
	var calendar: Calendar
	var dataManager: DataManager
	var cacheManager: CacheManager
	var neoCache: Cache<String, [Neo]>

	init(calendar: Calendar = .autoupdatingCurrent,
		 dataManager: DataManager = .init(),
		 cacheManager: CacheManager = .init()) {

		self.calendar = calendar
		self.dataManager = dataManager
		self.cacheManager = cacheManager
		self.neoCache = Cache<String, [Neo]>.init()
	}
}

// Make a global variable until a better way is found.
var appServices = AppServices()

//class MockServices: Services {
//	var calendar: Calendar = Calendar.autoupdatingCurrent
//	var neoCache: Cache<String, [Neo]> = Cache<String, [Neo]>()
//}

//struct World {
//	var notifications: (Notification) -> Void
//	var calendar: Calendar
//	var neoCache: Cache<String, [Neo]>
//}
//
//var CurrentEnvironment = World (
//	notifications: { notification in
//		NotificationCenter.default.post(notification)
//	},
//	calendar: .autoupdatingCurrent,
//	neoCache: Cache<String, [Neo]>()
//)

