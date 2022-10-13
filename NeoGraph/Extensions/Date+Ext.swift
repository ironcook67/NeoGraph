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

	func offsetBy(days: Int, hours: Int, minutes: Int = 0, seconds: Int = 0) -> Date {
		var components = DateComponents()
		components.day = days
		components.hour = hours
		components.minute = minutes
		components.second = seconds
		return Calendar.current.date(byAdding: components, to: self) ?? Date()
	}

	static var startOfTheHour: Date {
		let minute = Calendar.current.component(.minute, from: .now)
		return Calendar.current.date(byAdding: .minute, value: -minute, to: .now, wrappingComponents: false) ?? Date()
	}

	static var dayEarlierSameTime: Date {
		Date().offsetBy(days: -1, seconds: 0)
	}
	
	static var startOfToday: Date {
		Calendar.current.startOfDay(for: .now)
	}

	static var endOfToday: Date {
		endOfTheDay(for: .now)
	}

	static var startOfYesterday: Date {
		startOfToday.offsetBy(days: -1, seconds: 0)
	}

	static var startOfTomorrow: Date {
		startOfToday.offsetBy(days: 1, seconds: 0)
	}

	static func startOfPreviousDay(for date: Date) -> Date {
		Calendar.current.startOfDay(for: date).offsetBy(days: -1, seconds: 0)
	}

	static func startOfNextDay(for date: Date) -> Date {
		Calendar.current.startOfDay(for: date).offsetBy(days: 1, seconds: 0)
	}

	static func startOfTheDay(for date: Date) -> Date {
		Calendar.current.startOfDay(for: date)
	}

	static func endOfTheDay(for date: Date) -> Date {
		Calendar.current.startOfDay(for: date).offsetBy(days: 1, seconds: -1)
	}
}
