//
//  NeoGraphViewModel.swift
//  NeoGraph
//
//  Created by Chon Torres on 10/3/22.
//

import Foundation

extension NeoGraphView {
	@MainActor
	class ViewModel: ObservableObject {
		@Published private(set) var neos = [Neo]()
		@Published var isShowingHelpModal = false
		private(set) var lastStartTime: Date = Date().offsetBy(days: 0, seconds: -12 * 3600)

		func loadData() async {
			let dateToShow = lastStartTime
			let dateToShowEnd = dateToShow.offsetBy(days: 0, seconds: 12 * 3600)
			neos = await appServices.dataManager.getNeos(forRange: dateToShow...dateToShowEnd)
		}

		func loadData(_ date: Date) async {
			lastStartTime = date.offsetBy(days: 0, seconds: -12 * 3600)
			let dateToShow = lastStartTime
			let dateToShowEnd = dateToShow.offsetBy(days: 0, seconds: 12 * 3600)
			neos = await appServices.dataManager.getNeos(forRange: dateToShow...dateToShowEnd)
		}

		// MARK: - Testing
		func increment() async {
			lastStartTime = lastStartTime.offsetBy(days: 0, seconds: 3600)
			let dateToShow = lastStartTime
			let dateToShowEnd = dateToShow.offsetBy(days: 1, seconds: -1)
			print("Showing: \(dateToShow)")
			neos = await appServices.dataManager.getNeos(forRange: dateToShow...dateToShowEnd)
		}

		func decrement() async {
			lastStartTime = lastStartTime.offsetBy(days: 0, seconds: -3600)
			let dateToShow = lastStartTime
			let dateToShowEnd = dateToShow.offsetBy(days: 1, seconds: -1)
			print("Showing: \(dateToShow)")
			neos = await appServices.dataManager.getNeos(forRange: dateToShow...dateToShowEnd)
		}
	}
}
