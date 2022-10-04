//
//  Environment.swift
//  NeoGraph
//
//  Created by Chon Torres on 10/2/22.
//

import Foundation

struct World {
	var notifications: (Notification) -> Void
	var calendar: Calendar
	var neoCache: Cache<String, [Neo]>
}

var CurrentEnvironment = World (
	notifications: { notification in
		NotificationCenter.default.post(notification)
	},
	calendar: .autoupdatingCurrent,
	neoCache: Cache<String, [Neo]>()
)

