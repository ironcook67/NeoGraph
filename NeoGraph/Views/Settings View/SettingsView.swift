//
//  Settings.swift
//  NeoGraph
//
//  Created by Chon Torres on 10/7/22.
//

import SwiftUI

struct SettingsView: View {
	@State private var apiKey: String = appServices.apiKey

    var body: some View {
		List {
			Text("This app uses NASA's servers to get Near Earth Object details. The demo api key is DEMO_KEY and is limited to 30 requests per hour (which is fine for viewing the data on this app.)")

			Text("An API key can be generated on the NASA API website.")

			Link(destination: URL(string: "https://api.nasa.gov")!, label: {
				HStack {
					Text("NASA API website")
					LocationActionButton(color: .secondary, imageName: "network")
				}
			})
			.accessibilityRemoveTraits(.isButton)
			.accessibilityLabel(Text("Go to website"))

			Section(header: Text("NASA API")) {
				SectionDetailTextField(title: "Key", details: $apiKey)
			}
		}
		.onDisappear {
			appServices.apiKey = apiKey
		}
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

struct SectionDetailTextField: View {
	let title: String
	@Binding var details: String

	var body: some View {
		HStack {
			Text(title)
				.foregroundColor(Color.secondary)
			Spacer()
			TextField("", text: $details)
				.multilineTextAlignment(.trailing)
				.keyboardType(.alphabet)
				.disableAutocorrection(true)
				.autocapitalization(.words)
				.keyboardType(UIKeyboardType.default)
		}
	}
}

private struct LocationActionButton: View {
	var color: Color
	var imageName: String

	var body: some View {
		ZStack {
			Circle()
				.foregroundColor(color)
				.frame(width: 40, height: 40)
			Image(systemName: imageName)
				.resizable()
				.scaledToFit()
				.foregroundColor(.white)
				.frame(width: 22, height: 22)
		}
	}
}
