//
//  DataManager.swift
//  NeoGraph
//
//  Created by Chon Torres on 10/5/22.
//

import Foundation

class DataManager: ObservableObject {
	private var neoCache: Cache<String, [Neo]>

	init() {
		// Entries have a three day life. The server granularity is one full day of
		// Neo data. The times are in UTC, so to cover all of the local time zones
		// the day before and day after in local time is retrieved from the server.
		// If possible, the app will pre-fetch an additional day of data when the current day
		// is about to end. Expire after 4 days.
		// The other defaults are fine.
		self.neoCache = Cache<String, [Neo]>.init(entryLifetime: 4 * 24 * 3600)
	}

	func filterNeosByDate(_ neos: [Neo], by range: ClosedRange<Date>) -> [Neo] {
		// Filter out the points in the passed date range
		print("filterNeosByDate", "\(range)")
		return neos.filter { range.contains($0.closestApproachDate) }
	}

	// neoCache is indexed by days in UTC. Each date has all of the Neos
	// for that date in UTC.
	// The app should display information for the current time zone, which
	// will translate into needing to get two dates and filtering for the
	// local time zone.
	//
	func getNeos(forRange range: ClosedRange<Date>) async -> [Neo] {
		let start = Date()
		defer { print("getNeos", "Finished in", Date().timeIntervalSince(start)) }

		let utcLowerBound = Calendar.current.dateBySetting(timeZone: .current, of: range.lowerBound)!
		let utcUpperBound = Calendar.current.dateBySetting(timeZone: .current, of: range.upperBound)!

		let keyLowerBound = keyFromDate(utcLowerBound)
		let keyUpperBound = keyFromDate(utcUpperBound)

		// Reload the cache. The cache goes out of memory everytime the app
		// is not in the foregournd. The cache is small so this should be
		// quick.
		await loadCacheFromDisk()

		// Check if the neos are in Cache.
		var neos = [Neo]()
		if let neos1 = neoCache.value(forKey: keyLowerBound) {
			print("✅ Cache hit! \(keyLowerBound) - \(keyUpperBound)")
			neos.append(contentsOf: filterNeosByDate(neos1, by: range))

			if keyLowerBound != keyUpperBound {
				if let neos2 = neoCache.value(forKey: keyUpperBound) {
					neos.append(contentsOf: filterNeosByDate(neos2, by: range))
				}
			}

			return neos
		}

		print("💣 Cache miss! \(keyLowerBound) - \(keyUpperBound)")
		let apiService = APIService(urlString: NASAURLBuilder.urlString(
			start: .startOfPreviousDay(for: utcLowerBound),
			end: .startOfNextDay(for: utcUpperBound)))
		do {
			let neoService: NeoService = try await apiService.getJSON()
			let neoContainer = NeoContainer(from: neoService)
			for entry in neoContainer.neosByDay {
				// Insert into the Cache
				neoCache.insert(entry.value, forKey: entry.key)

				// Filter within the date range
				neos.append(contentsOf: filterNeosByDate(entry.value, by: range))
			}
		} catch {
			print("❌ Error - \(error.localizedDescription)")
		}

		// Save the cache to disk
		Task { await saveCacheToDisk() }

		return neos
	}

	// MARK: - Cache
	
	// Returns a Cache Key from a passed date, in UTC
	func keyFromDate(_ date: Date) -> String {
		return DateFormatter.NASADate.string(from: date)
	}

	func saveCacheToDisk() async {
		do {
			try neoCache.saveToDisk(withName: CacheConstants.neoCacheFilemame)
		} catch {
			print("saveCacheToDisk \(error.localizedDescription)")
		}
	}

	func loadCacheFromDisk() async {
		// 	Load the Neo Cache from disk, if it exsits.
		//	If the Neo Cache file does not exist, clear out the Neop Cache.
		// 	Remove old cached data.

		let fileURL = neoCache.getCacheFileURL(name: CacheConstants.neoCacheFilemame,
											   fileManager: FileManager.default)
		guard FileManager.default.fileExists(atPath: fileURL.path) else {
			return
		}

		// Read the Cache off of the disk.
		do {
			let data = try Data(contentsOf: fileURL)
			let decoder = JSONDecoder()
			neoCache = try decoder.decode(Cache<String, [Neo]>.self, from: data)
		} catch {
			print("loadCache \(error.localizedDescription)")
		}
	}

	enum CacheConstants {
		static let neoCacheFilemame = "neoCache"
	}
}
