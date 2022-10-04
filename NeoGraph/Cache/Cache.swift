//
//  Cache.swift
//  NeoGraph
//
//  Created by Chon Torres on 10/4/22.
// 	Based on Code from https://www.swiftbysundell.com/articles/caching-in-swift/
//

import Foundation

final class Cache<Key: Hashable, Value> {
	private let wrapped = NSCache<WrappedKey, Entry>()
	private let keyTracker = KeyTracker()

	init(maximumEntryCount: Int = 50) {
		wrapped.countLimit = maximumEntryCount
		wrapped.delegate = keyTracker
	}

	func insert(_ value: Value, forKey key: Key) {
		let entry = Entry(key: key, value: value)
		wrapped.setObject(entry, forKey: WrappedKey(key))
		keyTracker.keys.insert(key)
	}

	func value(forKey key: Key) -> Value? {
		guard let entry = wrapped.object(forKey: WrappedKey(key)) else {
			return nil
		}

		return entry.value
	}

	func removeValue(forKey key: Key) {
		wrapped.removeObject(forKey: WrappedKey(key))
	}

	func removeAll() {
		wrapped.removeAllObjects()
	}

	// MARK: - Supporting Classes
	final class WrappedKey: NSObject {
		let key: Key

		init(_ key: Key) { self.key = key }

		override var hash: Int { return key.hashValue }

		override func isEqual(_ object: Any?) -> Bool {
			guard let value = object as? WrappedKey else {
				return false
			}

			return value.key == key
		}
	}

	final class Entry {
		let key: Key
		let value: Value

		init(key: Key, value: Value) {
			self.key = key
			self.value = value
		}
	}

	final class KeyTracker: NSObject, NSCacheDelegate {
		var keys = Set<Key>()

		func cache(_ cache: NSCache<AnyObject, AnyObject>,
				   willEvictObject object: Any) {

			guard let entry = object as? Entry else {
				return
			}

			keys.remove(entry.key)
		}
	}
}

// MARK: - Codable
extension Cache.Entry: Codable where Key: Codable, Value: Codable {}

private extension Cache {
	func entry(forKey key: Key) -> Entry? {
		guard let entry = wrapped.object(forKey: WrappedKey(key)) else {
			return nil
		}

		return entry
	}

	func insert(_ entry: Entry) {
		wrapped.setObject(entry, forKey: WrappedKey(entry.key))
		keyTracker.keys.insert(entry.key)
	}
}

extension Cache: Codable where Key: Codable, Value: Codable {
	convenience init(from decoder: Decoder) throws {
		self.init()

		let container = try decoder.singleValueContainer()
		let entries = try container.decode([Entry].self)
		entries.forEach(insert)
		print("INIT: \(entries.count)")
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(keyTracker.keys.compactMap(entry))
	}
}

// Todo: Add functionality to filter expired keys.
extension Cache where Key: Codable, Value: Codable {
	func getCacheFileURL(name: String, fileManager: FileManager) -> URL {
		let folderURLs = fileManager.urls(
			for: .cachesDirectory,
			in: .userDomainMask
		)

		return folderURLs[0].appendingPathComponent(name + ".cache")
	}

	func saveToDisk(
		withName name: String,
		using fileManager: FileManager = .default
	) throws {
		let fileURL = getCacheFileURL(name: name, fileManager: fileManager)
		let encoder = JSONEncoder()
		let data = try encoder.encode(self)
		try data.write(to: fileURL)
	}
}
