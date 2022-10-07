//
//  XDismissButton.swift
//  NeoGraph
//
//  Created by Chon Torres on 10/6/22.
//

import SwiftUI

struct XDismissButton: View {
	var body: some View {
		ZStack {
			Circle()
				.frame(width: 30, height: 30)
				.foregroundColor(.white)
				.opacity(0.4)
			Image(systemName: "xmark")
				.foregroundColor(.white)
				.imageScale(.small)
				.frame(width: 44, height: 44)
		}
	}
}

struct XDismissButton_Previews: PreviewProvider {
	static var previews: some View {
		XDismissButton()
	}
}
