//
//  CacheManager.swift
//  NeoGraph
//
//  Created by Chon Torres on 10/4/22.
//

import Foundation

class CacheManager {
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

	func getNeos(forDate date: Date) async -> [Neo] {
		print("getNeos")
		// See if there is an array of Neos for the passed date.
		let cacheKey = keyFromDate(date)
		var neos = CurrentEnvironment.neoCache.value(forKey: cacheKey)
		if neos != nil {
			print("✅ Cache hit! \(cacheKey)")
			return neos!
		}
		print("💣 Cache miss! \(cacheKey)")

		// No neos in cache. Need to download.
		let apiService = APIService(urlString: NASAURLBuilder.urlString(start: .now, end: .startOfTomorrow))
		do {
			let neoService: NeoService = try await apiService.getJSON()
			let neoContainer = NeoContainer(from: neoService)
			for entry in neoContainer.neosByDay {
				if currentKey == entry.key {
					neos = entry.value
				}

				CurrentEnvironment.neoCache.insert(entry.value, forKey: entry.key)
			}
		} catch {
			print("❌ Error - \(error.localizedDescription)")
		}

		await saveCacheToDisk()

		return neos!
	}

	func saveCacheToDisk() async {
		do {
			try CurrentEnvironment.neoCache.saveToDisk(withName: CacheConstants.neoCacheFilemame)
		} catch {
			print("saveCacheToDisk \(error.localizedDescription)")
		}
	}

	func loadCacheFromDisk() async {
		// 	Load the Neo Cache from disk, if it exsits.
		//	If the Neo Cache file does not exist, clear out the Neop Cache.
		// 	Remove old cached data.

		let fileURL = CurrentEnvironment.neoCache.getCacheFileURL(name: CacheConstants.neoCacheFilemame, fileManager: FileManager.default)

		// Clear the Neo Cache
		CurrentEnvironment.neoCache.removeAll()

		// Read the Cache off of the disk.
		do {
			let data = try Data(contentsOf: fileURL)
			let decoder = JSONDecoder()
			CurrentEnvironment.neoCache = try decoder.decode(Cache<String, [Neo]>.self, from: data)
			
		} catch {
			print("loadCache \(error.localizedDescription)")
		}
	}
}
