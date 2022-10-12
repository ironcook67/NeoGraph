//
//  HelpModalView.swift
//  NeoGraph
//
//  Created by Chon Torres on 10/6/22.
//

import SwiftUI

struct HelpModalView: View {
	@Binding var isShowingHelpModal: Bool

	var body: some View {
		ZStack {
			VStack {
				Spacer()
				Text("Near-Earth Object Observations Program")
					.font(.title)
					.multilineTextAlignment(.center)
					.padding(.horizontal)
				Spacer()
				Group {
					Text("This app is displaying data from the NEO Observational Program. Its mission is to find, track, and characterize at least 90 percent of the predicted number of NEOs that are 140 meters and larger in size–larger than a small football stadium–and to characterize a subset representative of the entire population.")
					Text("\n")
					Text("The objects are plotted on a logarithmic scale.")
				}
				.multilineTextAlignment(.center)
				.padding(.horizontal)
				Spacer()
				Button("dismiss") {
					withAnimation { isShowingHelpModal = false }
				}
				Spacer()
			}
		}
		.transition(.opacity)
		.zIndex(2)
	}
}

struct HelpView_Previews: PreviewProvider {
	static var previews: some View {
		HelpModalView(isShowingHelpModal: .constant(true))
	}
}
