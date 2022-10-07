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

    var body: some View {
		VStack {
			ZStack {
				horizonView
					.ignoresSafeArea()

				VStack{
					Chart {
						ForEach(viewModel.neos) { neo in
							PointMark(
								x: .value("spread", neo.closestApproachDate!.timeIntervalSince(Calendar.current.startOfDay(for: neo.closestApproachDate!))),
								y: .value("distance", PlottableLength(measurement: neo.missDistance))
							)
						}
					}
					.chartOverlay { proxy in
						GeometryReader { geoProxy in
							if let yMoon = proxy.position(for: (0, Astronomical.moonDistance)) {
								let xMoon = geoProxy.size.width * 0.9
								Image("moon")
									.resizable()
									.frame(width: 50, height: 50)
									.position(CGPoint(x: xMoon, y: yMoon.y))
							}
						}
					}
					.chartXAxis(.hidden)
					.chartYScale(domain: 100_000...100_000_000, type: .log)
					.padding()
				}
				.animation(.linear, value: viewModel.neos)
			}
			.background {
				ZStack {
					Image("stars")
					Color.black
						.opacity(0.6)
				}
				.ignoresSafeArea()
			}

			HStack {
				Spacer()
				Button {
					Task { await viewModel.decrementDay() }
				} label: {
					Text("-")
						.frame(width: 40, height: 20)
				}
				Spacer()
				Button {
					Task { await viewModel.incrementDay() }
				} label: {
					Text("+")
						.frame(width: 40, height: 20)
				}
				Spacer()
			}
		}
		.task {
			await viewModel.loadData()
		}
    }

	var horizonView: some View {
		VStack {
			Spacer()

			HStack {
				Image("horizon")
					.resizable()
					.frame(height: 100)
					.offset(y: 40)
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NeoGraphView()
    }
}
