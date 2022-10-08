//
//  Settings.swift
//  NeoGraph
//
//  Created by Chon Torres on 10/7/22.
//

import SwiftUI

struct SettingsView: View {
	@State private var apiKey = appServices.apiKey

    var body: some View {
		List {
			Text("This app uses NASA's servers to get Near Earth Object details. The demo api key is DEMO_KEY and is limited to 30 requests per hour (which is fine for viewing the data on this app.)")

			Text("An API key can be generated on the NASA API website and pasted below:")

			Link(destination: URL(string: "https://api.nasa.gov")!, label: {
				HStack {
					Text("https://api.nasa.gov")
					Spacer()
					NetworkActionButton(color: .secondary, imageName: "network")
				}
			})
			.accessibilityRemoveTraits(.isButton)
			.accessibilityLabel(Text("Go to website"))

			Section(header: Text("NASA API")) {
				TextField("API_KEY", text: $apiKey, onCommit: {
					appServices.apiKey = apiKey.trimmingCharacters(in: .whitespacesAndNewlines)
					print("**\(appServices.apiKey)**")
				})
					.textFieldStyle(.roundedBorder)
					.keyboardType(.alphabet)
					.disableAutocorrection(true)
					.autocapitalization(.none)
			}
		}
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

private struct NetworkActionButton: View {
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
