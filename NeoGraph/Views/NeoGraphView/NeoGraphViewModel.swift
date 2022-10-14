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
		private(set) var lastStartTime: Date = Date().offsetBy(days: 0, hours: -12)

		func reportFound(neo: Neo) {
			let date = appServices.calendar.dateBySetting(timeZone: TimeZone.current, of: neo.closestApproachDate)!
			print("found", neo.name, "\(date.formatted())")
		}

		func neoDump() {
			for neo in neos.sorted() {
				let date = appServices.calendar.dateBySetting(timeZone: TimeZone.current, of: neo.closestApproachDate)!
				print("displayed", neo.name, "\(date.formatted())")
			}
		}

		func nextNeo() async -> Neo? {
			// Filter for the next Neos
			var startDate = lastStartTime
			let midDate = lastStartTime.offsetBy(days: 0, hours: 12)
			var endDate = startDate.offsetBy(days: 0, hours: 24)
			var foundNeos = [Neo]()
			var retrys = 0

			neoDump()

			print("attempt 0: \(startDate.formatted()) to \(endDate.formatted())")
			foundNeos = appServices.dataManager.filterNeosByDate(neos, by: midDate ... endDate)
			if foundNeos.first != nil {
				let neo = foundNeos.sorted().first!
				reportFound(neo: neo)
				return neo
			}

			while foundNeos.first == nil || retrys > 5 {
				retrys += 1
				startDate = endDate
				endDate = startDate.offsetBy(days: 1, seconds: 0)
				print("attempt \(retrys): \(startDate.formatted()) to \(endDate.formatted())")
				let fetchedNeos = await appServices.dataManager.getNeos(forRange: startDate ... endDate)
				foundNeos = appServices.dataManager.filterNeosByDate(fetchedNeos, by: startDate ... endDate)
			}

			if foundNeos.first != nil {
				let neo = foundNeos.sorted().first!
				reportFound(neo: neo)
				return neo
			}

			return foundNeos.first
		}

		func loadData() async {
			await loadData(.now)
		}

		func loadData(_ date: Date) async {
			print("loadData for \(date)")
			lastStartTime = date.offsetBy(days: 0, hours: -12)
			let dateToShow = lastStartTime
			let dateToShowEnd = dateToShow.offsetBy(days: 1, hours: 0)
			neos = await appServices.dataManager.getNeos(forRange: dateToShow...dateToShowEnd)
		}

		// MARK: - Testing
		func increment() async {
			lastStartTime = lastStartTime.offsetBy(days: 0, hours: 1)
			let dateToShow = lastStartTime
			let dateToShowEnd = dateToShow.offsetBy(days: 1, seconds: -1)
			print("Showing: \(dateToShow)")
			neos = await appServices.dataManager.getNeos(forRange: dateToShow...dateToShowEnd)
		}

		func decrement() async {
			lastStartTime = lastStartTime.offsetBy(days: 0, hours: -1)
			let dateToShow = lastStartTime
			let dateToShowEnd = dateToShow.offsetBy(days: 1, seconds: -1)
			print("Showing: \(dateToShow)")
			neos = await appServices.dataManager.getNeos(forRange: dateToShow...dateToShowEnd)
		}
	}
}
