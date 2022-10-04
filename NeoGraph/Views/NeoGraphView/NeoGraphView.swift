//
//  ContentView.swift
//  NeoGraph
//
//  Created by Chon Torres on 9/29/22.
//

import SwiftUI
import Charts

struct NeoGraphView: View {
	@StateObject var viewModel = ViewModel()

	let lunarDistance = 400000.0

    var body: some View {
		ZStack {
			VStack {
				Spacer()

				HStack {
					Image("horizon")
						.resizable()
						.frame(height: 100)
				}
			}
			.ignoresSafeArea()

			VStack{
				Chart {
					ForEach(viewModel.neos) { neo in
						PointMark(
							x: .value("spread", neo.closestApproachDateFull!.timeIntervalSince(Calendar.current.startOfDay(for: neo.closestApproachDateFull!))), // Int.random(in: 0...100)),
							y: .value("distance", PlottableLength(measurement: neo.missDistance))
						)
					}

					RuleMark(y: .value("moon", lunarDistance))
					PointMark(x: 100, y: .value("moon", lunarDistance))
						.symbol(.circle)
						.symbolSize(100.0)
				}
				.chartYScale(domain: .automatic(includesZero: true, reversed: false), type: .log)
				.chartXAxis(.hidden)
				.padding()
			}
		}
		.task {
			await viewModel.loadData()
		}
		.onDisappear {
			viewModel.saveCacheToDisk()
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NeoGraphView()
    }
}
