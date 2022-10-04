//
//  NASAURLBuilder.swift
//  NeoGraph
//
//  Created by Chon Torres on 10/4/22.
//

import Foundation

struct NASAURLBuilder {
	static let DEMO_KEY = "DEMO_KEY"
	// Todo: Do not release this API KEY
	static let API_KEY = "VP6e3MHCihUzVpKioZFfKe3wHoJjhYeandyKMr0m"

	static var prefix: String {
		return "https://api.nasa.gov/neo/rest/v1/feed?api_key=\(Self.API_KEY)"
	}

	// URL String for the current week of Neo data
	static func urlString() -> String {
		return Self.prefix
	}

//	// URL String for specific date
//	static func urlString(date: Date) -> String {
//		let dateString = DateFormatter.NASADate.string(from: date)
//		let tomorrowString = DateFormatter.NASADate.string(from: date.addingTimeInterval(.))
//		return Self.prefix + "&date\(dateString)"
//	}

	// URL String for a range of dates
	static private func urlString(start: String, end: String) -> String {
		return Self.prefix + "&start_date=\(start)&end_date=\(end)"
	}

	static func urlString(start: Date, end: Date) -> String {
		let startDate = DateFormatter.NASADate.string(from: start)
		let endDate = DateFormatter.NASADate.string(from: end)
		return Self.urlString(start: startDate, end: endDate)
	}
}
