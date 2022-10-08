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
		private var lastStartTime: Date = .startOfToday

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

//		func setDiplayedDate(to date: Date) async {
//			dateToShow = Date.startOfTheDay(for: date)
//			let dateToShowEnd = Date.endOfTheDay(for: dateToShow)
//			print("Showing: \(dateToShow)")
//			neos = await appServices.dataManager.getNeos(forRange: dateToShow...dateToShowEnd)
//		}

		func loadData() async {
			lastStartTime = Calendar.current.date(from: .init(timeZone: .current, year: 2022, month: 10, day: 13, hour: 0, minute: 0))!
			let dateToShow = lastStartTime
			let dateToShowEnd = Date.endOfTheDay(for: lastStartTime)
			neos = await appServices.dataManager.getNeos(forRange: dateToShow...dateToShowEnd)
		}
	}
}
