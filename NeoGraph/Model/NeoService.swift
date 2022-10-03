//
//  NeoService.swift
//  NeoGraph
//
//  Created by Chon Torres on 9/30/22.
//

import Foundation

struct NeoService: Decodable {
	private enum CodingKeys: String, CodingKey {
		case elementCount = "element_count"
		case links
		case neosByDate = "near_earth_objects"
	}

	let elementCount: Int
	let links: NeoLinks
	let neosByDate: [String: [NeoData]]

	struct NeoLinks: Decodable {
		private enum CodingKeys: String, CodingKey {
			case nextLink = "next"
			case previousLink = "previous"
			case thisLink = "self"
		}

		let nextLink: String
		let previousLink: String
		let thisLink: String
	}

	struct NeoData: Decodable {
		private enum CodingKeys: String, CodingKey {
			case absoluteMagnitudeH = "absolute_magnitude_h"
			case closestApproach = "close_approach_data"
			case estimatedDiameter = "estimated_diameter"
			case id
			case isPotentiallyHazerdousAsteroid = "is_potentially_hazardous_asteroid"
			case isSentryObject = "is_sentry_object"
			case links
			case name
			case nasaJPLURL = "nasa_jpl_url"
			case neoReferenceId = "neo_reference_id"
		}

		let absoluteMagnitudeH: Double
		let closestApproach: [ClosestApproachData]
		let estimatedDiameter: EstimatedDiameter
		let id: String
		let isPotentiallyHazerdousAsteroid: Bool
		let isSentryObject: Bool
		let links: Links
		let name: String
		let nasaJPLURL: String
		let neoReferenceId: String
	}

	struct ClosestApproachData: Decodable {
		private enum CodingKeys: String, CodingKey {
			case closeApproachDate = "close_approach_date"
			case closeApproachDateFull = "close_approach_date_full"
			case epochDateCloseApproach = "epoch_date_close_approach"
			case missDistance = "miss_distance"
			case orbitingBody = "orbiting_body"
			case relativeVelocity = "relative_velocity"
		}

		let closeApproachDate: String
		let closeApproachDateFull: String
		let epochDateCloseApproach: Int
		let missDistance: DistanceData
		let orbitingBody: String
		let relativeVelocity: VelocityData
	}

	struct DistanceData: Decodable {
		private enum CodingKeys: String, CodingKey {
			case astronomical
			case kilometers
			case lunar
			case miles
		}

		let astronomical: String
		let kilometers: String
		let lunar: String
		let miles: String
	}

	struct VelocityData: Decodable {
		private enum CodingKeys: String, CodingKey {
			case kph = "kilometers_per_hour"
			case kps = "kilometers_per_second"
			case mph = "miles_per_hour"
		}

		let kph: String
		let kps: String
		let mph: String
	}

	struct EstimatedDiameter: Decodable {
		private enum CodingKeys: String, CodingKey {
			case feet
			case kilometers
			case meters
			case miles
		}

		let feet: DiameterMinMax
		let kilometers: DiameterMinMax
		let meters: DiameterMinMax
		let miles: DiameterMinMax
	}

	struct DiameterMinMax: Decodable {
		private enum CodingKeys: String, CodingKey {
			case estimatedDiameterMax = "estimated_diameter_max"
			case estimatedDiameterMin = "estimated_diameter_min"
		}

		let estimatedDiameterMax: Double
		let estimatedDiameterMin: Double
	}

	struct Links: Decodable {
		private enum CodingKeys: String, CodingKey {
			case thisLink = "self"
		}

		let thisLink: String
	}
}
