//
//  NASAURLBuilder.swift
//  NeoGraph
//
//  Created by Chon Torres on 10/4/22.
//

import Foundation

struct NASAURLBuilder {
	static let DEMO_KEY = "DEMO_KEY"

	static var prefix: String {
		return "https://api.nasa.gov/neo/rest/v1/feed?api_key=\(appServices.apiKey)"
	}

	// URL String for the current week of Neo data
	static func urlString() -> String {
		return Self.prefix
	}

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
