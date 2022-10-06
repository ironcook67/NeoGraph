//
//  CacheManager.swift
//  NeoGraph
//
//  Created by Chon Torres on 10/4/22.
//

import Foundation

class CacheManager {
	private(set) var neos = [Neo]()
	private var initialCacheLoad = false
	var cacheNeedsReload = true

	enum CacheConstants {
		static let neoCacheFilemame = "neoCache"
	}

	// MARK: - Cache Keys
	var currentKey: String {
		keyFromDate(.now)
	}

	func keyFromDate(_ date: Date) -> String {
		return DateFormatter.NASADate.string(from: date)
	}

	func getNeos() async -> [Neo] {
		// 1. Check for Neos
		

		// 2. Load the file.

		return await getNeos(forDate: .now)
	}

	// Todo: Implement property handling of Time Zones
	func getNeos(forDate date: Date) async -> [Neo] {
		// 1. Reload the cache.
		await loadCacheFromDisk()

		// 2. Check if the neos are in the cache.
		let cacheKey = keyFromDate(date)
		var neos = appServices.neoCache.value(forKey: cacheKey)
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

				appServices.neoCache.insert(entry.value, forKey: entry.key)
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
		print("saveCacheToDisk")
		do {
			try appServices.neoCache.saveToDisk(withName: CacheConstants.neoCacheFilemame)
		} catch {
			print("saveCacheToDisk \(error.localizedDescription)")
		}
	}

	func loadCacheFromDisk() async {
		print("loadCacheFromDisk")
		// 	Load the Neo Cache from disk, if it exsits.
		//	If the Neo Cache file does not exist, clear out the Neop Cache.
		// 	Remove old cached data.

		let fileURL = appServices.neoCache.getCacheFileURL(name: CacheConstants.neoCacheFilemame, fileManager: FileManager.default)

//		// Clear the Neo Cache
//		appServices.neoCache.removeAll()

		// Read the Cache off of the disk.
		do {
			let data = try Data(contentsOf: fileURL)
			let decoder = JSONDecoder()
			appServices.neoCache = try decoder.decode(Cache<String, [Neo]>.self, from: data)
			
		} catch {
			print("loadCache \(error.localizedDescription)")
		}

		cacheNeedsReload = false
	}
}
