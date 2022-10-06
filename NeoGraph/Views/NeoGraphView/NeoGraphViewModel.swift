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

		@MainActor
		func loadData() async {
//			neos = await appServices.cacheManager.getNeos()
//			await appServices.cacheManager.loadCacheFromDisk()
			currentPage = appServices.cacheManager.currentKey
			neos = await appServices.cacheManager.getNeos(forDate: .now)
		}
	}
}
