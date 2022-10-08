//
//  Calendar+Ext.swift
//  NeoGraph
//
//  Created by Chon Torres on 10/7/22.
//

import Foundation

extension Calendar {
	// Convert the date to a new TimeZone while keeping the same moment.
	func dateBySetting(timeZone: TimeZone, of date: Date) -> Date? {
		var components = dateComponents(in: self.timeZone, from: date)
		components.timeZone = timeZone
		return self.date(from: components)
	}
}
