//
//  PlottableMeasurement.swift
//  NeoGraph
//
//  Created by Chon Torres on 10/4/22.
//

import Foundation
import Charts

struct PlottableLength<UnitType: Unit> {
	var measurement: Measurement<UnitType>
}

extension PlottableLength: Plottable where UnitType == UnitLength {
	var primitivePlottable: Double {
		self.measurement.converted(to: .kilometers).value
	}

	init?(primitivePlottable: Double) {
		self.init(
			measurement: Measurement(
				value: primitivePlottable, unit: .kilometers
			)
		)
	}
}
