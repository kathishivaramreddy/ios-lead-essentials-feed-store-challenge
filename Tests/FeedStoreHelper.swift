//
//  FeedStoreHelper.swift
//  Tests
//
//  Created by ShivaRamReddy on 02/02/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation

func setupEmptyStoreState(for test: AnyObject) {
	removeArtifactsFromMemory(for: test)
}

func undoStoreSideEffects(for test: AnyObject) {
	removeArtifactsFromMemory(for: test)
}

func cachesDirectory() -> URL {
	return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
}

func testSpecificUrl(for test: AnyObject) -> URL {
	return cachesDirectory().appendingPathComponent("\(type(of:test))-test.store")
}

func removeArtifactsFromMemory(for test: AnyObject) {
	try? FileManager.default.removeItem(at: testSpecificUrl(for: test))
}
