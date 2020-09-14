//
// Copyright © 2020 Stormwright. All rights reserved.
//

import XCTest
import MoneyConverterEngine

class MoneyConverterEngineCacheIntegrationTests: XCTestCase {

    override func setUp() {
        super.setUp()
        
        setupEmptyStoreState()
    }
    
    override func tearDown() {
        super.tearDown()
        
        undoStoreSideEffects()
    }
    
    func test_loadRatesFeed_deliversNoItemsOnEmptyCache() {
        let feedLoader = makeRatesFeedLoader()

        expect(feedLoader, toLoad: [])
    }
    
    func test_loadFeed_deliversItemsSavedOnASeparateInstance() {
        let feedLoaderToPerformSave = makeRatesFeedLoader()
        let feedLoaderToPerformLoad = makeRatesFeedLoader()
        let feed = uniqueRatesFeed().models
        
        save(feed, with: feedLoaderToPerformSave)

        expect(feedLoaderToPerformLoad, toLoad: feed)
    }
    
    func test_validateFeedCache_doesNotDeleteRecentlySavedFeed() {
        let feedLoaderToPerformSave = makeRatesFeedLoader()
        let feedLoaderToPerformValidation = makeRatesFeedLoader()
        let feed = uniqueRatesFeed().models
        
        save(feed, with: feedLoaderToPerformSave)
        validateCache(with: feedLoaderToPerformValidation)
        
        expect(feedLoaderToPerformSave, toLoad: feed)
    }
    
    func test_validateFeedCache_deletesFeedSavedInADistantPast() {
        let feedLoaderToPerformSave = makeRatesFeedLoader(currentDate: .distantPast)
        let feedLoaderToPerformValidation = makeRatesFeedLoader(currentDate: Date())
        let feed = uniqueRatesFeed().models
        
        save(feed, with: feedLoaderToPerformSave)
        validateCache(with: feedLoaderToPerformValidation)

        expect(feedLoaderToPerformSave, toLoad: [])
    }
    
    // MARK: - Helpers
    
    private func makeRatesFeedLoader(currentDate: Date = Date(), file: StaticString = #file, line: UInt = #line) -> LocalRatesFeedLoader {
        let storeURL = testSpecificStoreURL()
        let store = try! CoreDataRatesFeedStore(storeURL: storeURL)
        let sut = LocalRatesFeedLoader(store: store, currentDate: { currentDate })
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    private func expect(_ sut: LocalRatesFeedLoader, toLoad expectedFeed: [FeedRate], file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        sut.load { result in
            switch result {
            case let .success(loadedFeed):
                XCTAssertEqual(loadedFeed, expectedFeed, file: file, line: line)
                
            case let .failure(error):
                XCTFail("Expected successful feed result, got \(error) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    private func save(_ feed: [FeedRate], with loader: LocalRatesFeedLoader, file: StaticString = #file, line: UInt = #line) {
        let saveExp = expectation(description: "Wait for save completion")
        loader.save(feed) { result in
            if case let Result.failure(error) = result {
                XCTFail("Expected to save feed successfully, got error: \(error)", file: file, line: line)
            }
            saveExp.fulfill()
        }
        wait(for: [saveExp], timeout: 1.0)
    }
    
    private func validateCache(with loader: LocalRatesFeedLoader, file: StaticString = #file, line: UInt = #line) {
        let saveExp = expectation(description: "Wait for save completion")
        loader.validateCache() { result in
            if case let Result.failure(error) = result {
                XCTFail("Expected to validate feed successfully, got error: \(error)", file: file, line: line)
            }
            saveExp.fulfill()
        }
        wait(for: [saveExp], timeout: 1.0)
    }
    
    private func setupEmptyStoreState() {
        deleteStoreArtifacts()
    }
    
    private func undoStoreSideEffects() {
        deleteStoreArtifacts()
    }
    
    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }
    
    private func testSpecificStoreURL() -> URL {
        return cachesDirectory().appendingPathComponent("\(type(of: self)).store")
    }
    
    private func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
}
