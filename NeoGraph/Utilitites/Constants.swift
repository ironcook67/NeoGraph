//
//  Constants.swift
//  NeoGraph
//
//  Created by Chon Torres on 9/29/22.
//

import SwiftUI

enum Theme {
	static let background = Color("background")
	static let detailBackground = Color("detail-background")
	static let text = Color("text")
	static let accent = Color("AccentColor")
}

// MARK: - Networking Errors

enum NetworkError: Error {
	case invalidURL
	case invalidResponse
	case invalidData
}
