//
//  DateFormatter+Ext.swift
//  NeoGraph
//
//  Created by Chon Torres on 10/2/22.
//

import Foundation

extension DateFormatter {
	static let NASADate: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd"
		formatter.calendar = Calendar(identifier: .iso8601)
		formatter.locale = Locale(identifier: "en_US_POSIX")
//		formatter.timeZone = TimeZone(abbreviation: "UTC")
		return formatter
	}()

	static let NASAFullUTCDate: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd HH:mm"
		formatter.calendar = Calendar(identifier: .iso8601)
		formatter.locale = Locale(identifier: "en_US_POSIX")
//		formatter.timeZone = TimeZone(abbreviation: "UTC")
		return formatter
	}()
}
