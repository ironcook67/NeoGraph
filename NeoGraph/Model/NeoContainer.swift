//
//  NeoContainer.swift
//  NeoGraph
//
//  Created by Chon Torres on 9/30/22.
//

import Foundation

struct NeoContainer: Codable {
	// Keys are strings of dates in "yyyy-MM-dd" format.
	var neosByDay = [String: [Neo]]()
}

extension NeoContainer {
	init(from service: NeoService) {
		let nasaDateFormatter = DateFormatter.NASAFullUTCDate
		nasaDateFormatter.timeZone = .gmt
		
		for date in service.neosByDate {

			var neos = [Neo]()

			let neoDataPoints = date.value
			for neoData in neoDataPoints {
				guard let closestApproachData = neoData.closestApproach.first else { continue }
				let distance = Double(closestApproachData.missDistance.kilometers) ?? 0.0
				let velocity = Double(closestApproachData.relativeVelocity.kph) ?? 0.0
				let approachDateFull = nasaDateFormatter.date(from: closestApproachData.closeApproachDateFull) ?? Date()

				let neo = Neo(id: neoData.id,
							  name: neoData.name,
							  nasaReferenceId: neoData.nasaJPLURL,
							  closestApproachDate: approachDateFull,
							  magnitude: neoData.absoluteMagnitudeH,
							  missDistance: Measurement(value: distance, unit: .kilometers),
							  relativeVelocity: Measurement(value: velocity, unit: .kilometersPerHour),
							  esitmatedDiameterMin: Measurement(value: neoData.estimatedDiameter.kilometers.estimatedDiameterMin, unit: .kilometers),
							  estimatedDiameterMax: Measurement(value: neoData.estimatedDiameter.kilometers.estimatedDiameterMax, unit: .kilometers),
							  isPotentiallyHazardous: neoData.isPotentiallyHazerdousAsteroid,
							  isSentryObject: neoData.isSentryObject,
							  URL: neoData.links.thisLink,
							  JPLURL: neoData.nasaJPLURL)
				neos.append(neo)
			}

			self.neosByDay[date.key] = neos
		}
	}
}


