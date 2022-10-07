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
		private var dateToShow: Date = .now

		func incrementDay() async {
			dateToShow = Date.startOfNextDay(for: dateToShow)
			print("Showing: \(dateToShow)")
			neos = await appServices.dataManager.getNeos(forDate: dateToShow)
		}

		func decrementDay() async {
			dateToShow = Date.startOfPreviousDay(for: dateToShow)
			print("Showing: \(dateToShow)")
			neos = await appServices.dataManager.getNeos(forDate: dateToShow)
		}

		func setDiplayedDate(to date: Date) async {
			dateToShow = date
			print("Showing: \(dateToShow)")
			neos = await appServices.dataManager.getNeos(forDate: dateToShow)
		}

		func loadData() async {
			print("Showing: \(dateToShow)")
			neos = await appServices.dataManager.getNeos(forDate: dateToShow)
		}
	}
}
