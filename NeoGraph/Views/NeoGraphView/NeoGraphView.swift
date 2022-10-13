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
	@State private var showPreferences = false

    var body: some View {
		ZStack {
			VStack {
				topButtons

				ZStack {
					horizonView
						.ignoresSafeArea()

					VStack{
						Chart {
							ForEach(viewModel.neos) { neo in
								PointMark(
									x: .value("spread", neo.closestApproachDate.timeIntervalSince(viewModel.lastStartTime)),
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

				testingButtons
			}
			if viewModel.isShowingHelpModal {
				FullScreenBlackTransparencyView()
				HelpModalView(isShowingHelpModal: $viewModel.isShowingHelpModal)
			}
		}
		.sheet(isPresented: $showPreferences) {
			NavigationView {
				SettingsView()
					.toolbar {
						ToolbarItem(placement: .navigationBarTrailing) {
							Button {
								withAnimation { showPreferences = false }
							} label: {
								XDismissButton()
							}
						}
					}
					.navigationTitle("Settings")
			}
		}
		.background {
			ZStack {
				Image("stars")
				Color.black
					.opacity(0.6)
			}
			.ignoresSafeArea()
		}
		.task {
			await viewModel.loadData()
		}
    }

	var topButtons: some View {
		HStack {
			Button {
				showPreferences = true
			} label: {
				Image(systemName: "gearshape.fill")
					.font(.title3)
					.frame(width: 44, height: 44)
					.padding(.horizontal)
			}
			Spacer()
			Button {
				withAnimation {
					viewModel.isShowingHelpModal = true
				}
			} label: {
				Image(systemName: "questionmark.circle")
					.font(.title3)
					.frame(width: 44, height: 44)
					.padding(.horizontal)
			}
		}
		.foregroundColor(.mint)
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

	var testingButtons: some View {
		HStack {
			Spacer()
			Button {
				Task { await viewModel.decrement() }
			} label: {
				Text("-")
					.frame(width: 40, height: 20)
			}
			Button {
				Task { await viewModel.nextNeo() }
			} label: {
				Image(systemName: "plus.circle")
					.frame(width: 40, height: 20)
			}
			Button {
				Task { await viewModel.increment() }
			} label: {
				Text("+")
					.frame(width: 40, height: 20)
			}
			Spacer()
		}
	}
}

private struct FullScreenBlackTransparencyView: View {
	var body: some View {
		Color(.black)
			.ignoresSafeArea()
			.opacity(0.8)
			.transition(AnyTransition.opacity.animation(.easeOut(duration: 0.35)))
			.zIndex(1)
			.accessibilityHidden(true)
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NeoGraphView()
			.preferredColorScheme(.dark)
    }
}

