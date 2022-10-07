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
			currentPage = appServices.dataManager.currentKey
			neos = await appServices.dataManager.getNeos(forDate: Date())
		}
	}
}
