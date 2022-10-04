//
//  Date+Ext.swift
//  NeoGraph
//
//  Created by Chon Torres on 10/4/22.
//

import Foundation

extension Date {
	func offsetBy(days: Int, seconds: Int) -> Date {
		var components = DateComponents()
		components.day = days
		components.second = seconds
		return Calendar.current.date(byAdding: components, to: self) ?? Date()
	}

	static var startOfToday: Date {
		Calendar.current.startOfDay(for: Date.now)
	}

	static var startOfTomorrow: Date {
		startOfToday.offsetBy(days: 1, seconds: 0)
	}

	static func startOfTheDay(for date: Date) -> Date {
		Calendar.current.startOfDay(for: date)
	}

	static func endOfTheDay(for date: Date) -> Date {
		Calendar.current.startOfDay(for: date).offsetBy(days: 1, seconds: -1)
	}
}