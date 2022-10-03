//
//  NeoContainer.swift
//  NeoGraph
//
//  Created by Chon Torres on 9/30/22.
//

import Foundation

struct NeoContainer: Codable {
	var neosByDay = [String: [Neo]]()
}

extension NeoContainer {
	init(from service: NeoService) {
		let nasaDateFormatter = DateFormatter.NASAFullUTCDate

		for date in service.neosByDate {

			var neos = [Neo]()

			let neoDataPoints = date.value
			for neoData in neoDataPoints {
				guard let closestApproachData = neoData.closestApproach.first else { continue }
				let distance = Double(closestApproachData.missDistance.kilometers) ?? 0.0
				let velocity = Double(closestApproachData.relativeVelocity.kps) ?? 0.0
				let approachDateFull = nasaDateFormatter.date(from: closestApproachData.closeApproachDateFull)

				let neo = Neo(id: neoData.id,
							  name: neoData.name,
							  nasaReferenceId: neoData.nasaJPLURL,
							  closestApproachDate: closestApproachData.closeApproachDate,
							  closestApproachDateFull: approachDateFull,
							  magnitude: neoData.absoluteMagnitudeH,
							  missDistanceKm: distance,
							  relativeVelocityKPS: velocity,
							  esitmatedDiameterMinKm: neoData.estimatedDiameter.kilometers.estimatedDiameterMin,
							  estimatedDiameterMaxKm: neoData.estimatedDiameter.kilometers.estimatedDiameterMax,
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


