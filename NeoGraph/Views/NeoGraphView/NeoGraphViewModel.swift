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

		func loadData() {
			// Get the data from the sample data
			let neoService = Bundle.main.decode(NeoService.self, from: "sample-data.json")
			let neoContainer = NeoContainer(from: neoService)
			guard let firstDate = neoContainer.neosByDay.first?.key else {
				print("Could not get sample data")
				return
			}

			if neoContainer.neosByDay[firstDate] != nil {
				neos = neoContainer.neosByDay[firstDate]!
				currentPage = firstDate
			} else {
				neos = []
			}
		}
	}
}
