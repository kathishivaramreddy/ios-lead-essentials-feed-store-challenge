//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import XCTest
import FeedStoreChallenge


class FeedStoreChallengeTests: XCTestCase, FeedStoreSpecs {
	
	//  ***********************
	//
	//  Follow the TDD process:
	//
	//  1. Uncomment and run one test at a time (run tests with CMD+U).
	//  2. Do the minimum to make the test pass and commit.
	//  3. Refactor if needed and commit again.
	//
	//  Repeat this process until all tests are passing.
	//
	//  ***********************
	
	override func setUp() {
		super.setUp()
		setupMemoryBeforeTest()
	}
	
	override func tearDown() {
		super.tearDown()
		clearMemoryAfterTest()
		try? FileManager.default.removeItem(at: testSpecificUrl())
	}
	
	func test_retrieve_deliversEmptyOnEmptyCache() {
		let sut = makeSUT()
		
		assertThatRetrieveDeliversEmptyOnEmptyCache(on: sut)
	}
	
	func test_retrieve_hasNoSideEffectsOnEmptyCache() {
		let sut = makeSUT()
		
		assertThatRetrieveHasNoSideEffectsOnEmptyCache(on: sut)
	}
	
	func test_retrieve_deliversFoundValuesOnNonEmptyCache() {
		let sut = makeSUT()
		
		assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on: sut)
	}
	
	func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
		let sut = makeSUT()
		
		assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on: sut)
	}
	
	func test_insert_deliversNoErrorOnEmptyCache() {
		let sut = makeSUT()
		
		assertThatInsertDeliversNoErrorOnEmptyCache(on: sut)
	}
	
	func test_insert_deliversNoErrorOnNonEmptyCache() {
		let sut = makeSUT()
		
		assertThatInsertDeliversNoErrorOnNonEmptyCache(on: sut)
	}
	
	func test_insert_overridesPreviouslyInsertedCacheValues() {
		let sut = makeSUT()
		
		assertThatInsertOverridesPreviouslyInsertedCacheValues(on: sut)
	}
	
	func test_delete_deliversNoErrorOnEmptyCache() {
		let sut = makeSUT()
		
		assertThatDeleteDeliversNoErrorOnEmptyCache(on: sut)
	}
	
	func test_delete_hasNoSideEffectsOnEmptyCache() {
		let sut = makeSUT()
		
		assertThatDeleteHasNoSideEffectsOnEmptyCache(on: sut)
	}
	
	func test_delete_deliversNoErrorOnNonEmptyCache() {
		let sut = makeSUT()
		
		assertThatDeleteDeliversNoErrorOnNonEmptyCache(on: sut)
	}
	
	func test_delete_emptiesPreviouslyInsertedCache() {
		let sut = makeSUT()
		
		assertThatDeleteEmptiesPreviouslyInsertedCache(on: sut)
	}
	
	func test_storeSideEffects_runSerially() {
		let sut = makeSUT()
		
		assertThatSideEffectsRunSerially(on: sut)
	}
	
	// - MARK: Helpers
	
	private func makeSUT(storeUrl: URL? = nil, file: StaticString = #filePath, line: UInt = #line) -> FeedStore {
		let sut = CodableFeedStore(storeUrl: storeUrl ?? testSpecificUrl())
		memoryLeakTracker(instance: sut, file: file, line: line)
		return sut
	}
	
	private func memoryLeakTracker(instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
		addTeardownBlock { [weak instance] in
			XCTAssertNil(instance)
		}
	}
	
	private func cachesDirectory() -> URL {
		return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
	}
	
	private func testSpecificUrl() -> URL {
		return cachesDirectory().appendingPathComponent("\(type(of:self))-test.store")
	}
	
	private func setupMemoryBeforeTest() {
		removeArtifcatsFromMemory()
	}
	
	private func clearMemoryAfterTest() {
		removeArtifcatsFromMemory()
	}
	
	private func removeArtifcatsFromMemory() {
		try? FileManager.default.removeItem(at: testSpecificUrl())
	}
}

//  ***********************
//
//  Uncomment the following tests if your implementation has failable operations.
//
//  Otherwise, delete the commented out code!
//
//  ***********************

extension FeedStoreChallengeTests: FailableRetrieveFeedStoreSpecs {

	func test_retrieve_deliversFailureOnRetrievalError() {
		let sut = makeSUT()
		
		writeInvalidDateToMemory()
		assertThatRetrieveDeliversFailureOnRetrievalError(on: sut)
	}

	func test_retrieve_hasNoSideEffectsOnFailure() {
		let sut = makeSUT()
		writeInvalidDateToMemory()
		assertThatRetrieveHasNoSideEffectsOnFailure(on: sut)
	}
	
	private func writeInvalidDateToMemory() {
		try! "InvalidData".write(to: testSpecificUrl(), atomically: false, encoding: .utf8)
	}
}

extension FeedStoreChallengeTests: FailableInsertFeedStoreSpecs {
	
	func test_insert_deliversErrorOnInsertionError() {
		
		let sut = makeSUT(storeUrl: inValidStoreUrl())
		
		assertThatInsertDeliversErrorOnInsertionError(on: sut)
	}
	
	func test_insert_hasNoSideEffectsOnInsertionError() {
		
		let sut = makeSUT(storeUrl: inValidStoreUrl())
		
		assertThatInsertHasNoSideEffectsOnInsertionError(on: sut)
	}
	
	private func inValidStoreUrl() -> URL {
		return cachesDirectory().appendingPathComponent("invalid//:store")
	}
}

extension FeedStoreChallengeTests: FailableDeleteFeedStoreSpecs {

	func test_delete_deliversErrorOnDeletionError() {
		let noDeletePermissionStoreUrl = cachesDirectory()
		let sut = makeSUT(storeUrl: noDeletePermissionStoreUrl)
		
		assertThatDeleteDeliversErrorOnDeletionError(on: sut)
	}

	func test_delete_hasNoSideEffectsOnDeletionError() {
		let noDeletePermissionStoreUrl = cachesDirectory()
		let sut = makeSUT(storeUrl: noDeletePermissionStoreUrl)
		
		assertThatDeleteHasNoSideEffectsOnDeletionError(on: sut)
	}

}
