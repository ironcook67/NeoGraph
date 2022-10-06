//
//  DataManager.swift
//  NeoGraph
//
//  Created by Chon Torres on 10/5/22.
//

import Foundation

class DataManager: ObservableObject {
	private(set) var neoCache: CacheManager

	init() {
		neoCache = CacheManager()
	}
}
