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
						.offset(y: 40)
				}
			}
			.ignoresSafeArea()

			VStack{
				Chart {
					ForEach(viewModel.neos) { neo in
						PointMark(
							x: .value("spread", neo.closestApproachDateFull!.timeIntervalSince(Calendar.current.startOfDay(for: neo.closestApproachDateFull!))),
							y: .value("distance", PlottableLength(measurement: neo.missDistance))
						)
					}

//					PointMark(x: -1, y: .value("earth", 1))
//						.symbol(.cross)
//						.symbolSize(0)

					PointMark(x: -1, y: .value("moon", lunarDistance))
						.symbol(.cross)
						.symbolSize(0)
				}
				.chartOverlay { proxy in
					GeometryReader { geoProxy in
						if let yMoon = proxy.position(for: (0, 400_400)) {
							let xMoon = geoProxy.size.width * 0.9
							Image("moon")
								.resizable()
								.frame(width: 50, height: 50)
								.position(CGPoint(x: xMoon, y: yMoon.y))
						}
					}
				}
				.chartYScale(domain: .automatic(includesZero: true, reversed: false), type: .log)
				.chartXAxis(.hidden)
				.padding()
			}
		}
		.task {
			await viewModel.loadData()
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NeoGraphView()
    }
}
