//
//  Neo.swift
//  NeoGraph
//
//  Created by Chon Torres on 9/29/22.
//

import Foundation

struct Neo: Codable, Hashable, Identifiable, Comparable {
	let id: String
	let name: String
	let nasaReferenceId: String
	let closestApproachDate: Date
	let magnitude: Double
	let missDistance: Measurement<UnitLength>
	let relativeVelocity: Measurement<UnitSpeed>
	let esitmatedDiameterMin: Measurement<UnitLength>
	let estimatedDiameterMax: Measurement<UnitLength>
	let isPotentiallyHazardous: Bool
	let isSentryObject: Bool
	let URL: String
	let JPLURL: String

	static func < (lhs: Neo, rhs: Neo) -> Bool {
		lhs.closestApproachDate < rhs.closestApproachDate
	}
}

extension Neo {
	var averageDiameter: Measurement<UnitLength> {
		(esitmatedDiameterMin + estimatedDiameterMax) / 2.0
	}
}


