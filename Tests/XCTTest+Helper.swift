//
//  XCTTest+Helper.swift
//  Tests
//
//  Created by ShivaRamReddy on 02/02/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation
import XCTest

extension XCTestCase {
	
	func memoryLeakTracker(instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
		addTeardownBlock { [weak instance] in
			XCTAssertNil(instance, file: file, line: line)
		}
	}
}

extension XCTestCase {
		
	func removeArtifactsFromMemory() {
		try? FileManager.default.removeItem(at: testSpecificUrl())
	}
	
	func setupEmptyStoreState() {
		removeArtifactsFromMemory()
	}

	func undoStoreSideEffects() {
		removeArtifactsFromMemory()
	}

	func cachesDirectory() -> URL {
		return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
	}

	func testSpecificUrl() -> URL {
		return cachesDirectory().appendingPathComponent("\(type(of:self))-test.store")
	}
}
