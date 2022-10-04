//
//  PlottableSpeed.swift
//  NeoGraph
//
//  Created by Chon Torres on 10/4/22.
//

import Foundation
import Charts

struct PlottableSpeed<UnitType: Unit> {
	var measurement: Measurement<UnitType>
}

// MARK: - Speed
extension PlottableSpeed: Plottable where UnitType == UnitSpeed {
	var primitivePlottable: Double {
		self.measurement.converted(to: .kilometersPerHour).value
	}

	init?(primitivePlottable: Double) {
		self.init(
			measurement: Measurement(
				value: primitivePlottable, unit: .kilometersPerHour
			)
		)
	}
}
