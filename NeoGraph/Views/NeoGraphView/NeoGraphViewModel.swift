//
//  NeoGraphViewModel.swift
//  NeoGraph
//
//  Created by Chon Torres on 10/3/22.
//

import Foundation

extension NeoGraphView {
	class ViewModel: ObservableObject {
		@Published private(set) var currentPage: String?
		@Published private(set) var neos = [Neo]()

		private var cacheManager = CacheManager()

		@MainActor
		func loadData() async {
			await cacheManager.loadCacheFromDisk()
			currentPage = cacheManager.currentKey
			neos = await cacheManager.getNeos(forDate: .now)
		}
	}
}
