//
//  Neo.swift
//  NeoGraph
//
//  Created by Chon Torres on 9/29/22.
//

import Foundation

struct Neo: Codable, Hashable, Identifiable {
	let id: String
	let name: String
	let nasaReferenceId: String
	let closestApproachDate: String
	let closestApproachDateFull: Date?
	let magnitude: Double
	let missDistanceKm: Double
	let relativeVelocityKPS: Double
	let esitmatedDiameterMinKm: Double
	let estimatedDiameterMaxKm: Double
	let isPotentiallyHazardous: Bool
	let isSentryObject: Bool
	let URL: String
	let JPLURL: String
}



