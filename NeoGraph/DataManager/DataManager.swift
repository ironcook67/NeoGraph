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

	// MARK: - Cache Keys
	var currentKey: String {
		keyFromDate(.now)
	}

	func keyFromDate(_ date: Date) -> String {
		return DateFormatter.NASADate.string(from: date)
	}

	// Todo: Implement property handling of Time Zones
	func getNeos(forDate date: Date) async -> [Neo] {
		let start = Date()
		defer { print("Some Msg", "Finished in", Date().timeIntervalSince(start)) }

		// 1. Reload the cache.
		await loadCacheFromDisk()

		// 2. Check if the neos are in the cache.
		let cacheKey = keyFromDate(date)
		var neos = neoCache.value(forKey: cacheKey)
		if neos != nil {
			print("✅ Cache hit! \(cacheKey)")
			return neos!
		}

		// 3. Download neos for yesterday through tomorrow.
		// 	  The reported data is in UTC and this will ensure
		//	  the right local display.

		print("💣 Cache miss! \(cacheKey)")
		let apiService = APIService(urlString: NASAURLBuilder.urlString(
			start: .startOfPreviousDay(for: date),
			end: .startOfNextDay(for: date)))
		do {
			let neoService: NeoService = try await apiService.getJSON()
			let neoContainer = NeoContainer(from: neoService)
			for entry in neoContainer.neosByDay {
				if currentKey == entry.key {
					neos = entry.value
				}

				neoCache.insert(entry.value, forKey: entry.key)
			}
		} catch {
			print("❌ Error - \(error.localizedDescription)")
		}

		Task {
			await saveCacheToDisk()
		}

		return neos!
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

		let fileURL = neoCache.getCacheFileURL(name: CacheConstants.neoCacheFilemame, fileManager: FileManager.default)

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
