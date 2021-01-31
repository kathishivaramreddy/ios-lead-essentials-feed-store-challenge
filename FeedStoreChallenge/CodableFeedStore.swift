//
//  CodableFeedStore.swift
//  FeedStoreChallenge
//
//  Created by ShivaRamReddy on 31/01/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation

public final class CodableFeedStore: FeedStore {
	
	private struct Cache: Codable {
		let items: [CodableFeedImage]
		let timeStamp: Date
		
		var local: [LocalFeedImage] {
			return items.map { $0.localFeed }
		}
	}
	
	private struct CodableFeedImage: Codable {
		private let id: UUID
		private let description: String?
		private let location: String?
		private let imageURL: URL
		
		init(_ feed: LocalFeedImage) {
			self.id = feed.id
			self.description = feed.description
			self.location = feed.location
			self.imageURL = feed.url
		}
		
		var localFeed: LocalFeedImage {
			return LocalFeedImage(id: id
				, description: description
				, location: location
				, url: imageURL)
		}
	}
	
	private let storeUrl: URL
	
	public init(storeUrl: URL) {
		self.storeUrl = storeUrl
	}
	
	private let queue = DispatchQueue(label: "CodableFeedStore", qos: .userInitiated, attributes: .concurrent)
	
	public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
		let storeUrl = self.storeUrl
		queue.async(flags: .barrier) {
			guard FileManager.default.fileExists(atPath: storeUrl.path) else {
				return completion(nil)
			}
			
			do {
				try FileManager.default.removeItem(at: self.storeUrl)
				completion(nil)
			} catch {
				completion(error)
			}
		}
	}
	
	public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
		let storeUrl = self.storeUrl
		queue.async(flags: .barrier) {
			do {
				let encodedData = try! JSONEncoder().encode(Cache(items: feed.map { CodableFeedImage($0) } , timeStamp: timestamp))
				try encodedData.write(to: storeUrl)
				completion(nil)
			} catch {
				
				completion(error)
			}
		}
	}
	
	public func retrieve(completion: @escaping RetrievalCompletion) {
		let storeUrl = self.storeUrl
		queue.async {
			guard let encodedData = try? Data(contentsOf: storeUrl) else {
				return completion(.empty)
			}
			
			do {
				let decodedData = try JSONDecoder().decode(Cache.self, from: encodedData)
				completion(.found(feed: decodedData.local, timestamp: decodedData.timeStamp))
			} catch {
				completion(.failure(error))
			}
		}
	}
}
