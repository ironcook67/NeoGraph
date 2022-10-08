//
//  HelpModalView.swift
//  NeoGraph
//
//  Created by Chon Torres on 10/6/22.
//

import SwiftUI

struct HelpModalView: View {
	@Binding var isShowingHelpModal: Bool
//	@StateObject private var viewModel = ViewModel()

	var body: some View {
		ZStack {
			// Color.black.edgesIgnoringSafeArea(.all)
			VStack {
				Text("I'm Here to Help!")
				Button("dismiss") {
					withAnimation { isShowingHelpModal = false }
				}
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
