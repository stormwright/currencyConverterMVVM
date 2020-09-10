//
// Copyright © 2020 Stormwright. All rights reserved.
//

import XCTest
import MoneyConverterEngine

extension RatesFeedStoreSpecs where Self: XCTestCase {
    
    func assertThatRetrieveDeliversEmptyOnEmptyCache(on sut: RatesFeedStore, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
    
    func assertThatRetrieveHasNoSideEffectsOnEmptyCache(on sut: RatesFeedStore, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieveTwice: .success(.none), file: file, line: line)
    }
    
    func assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on sut: RatesFeedStore, file: StaticString = #file, line: UInt = #line) {
        let feed = uniqueRatesFeed().local
        let timestamp = Date()
        
        insert((feed, timestamp), to: sut)
        
        expect(sut, toRetrieve: .success(CachedFeed(feed: feed, timestamp: timestamp)), file: file, line: line)
    }
    
    func assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on sut: RatesFeedStore, file: StaticString = #file, line: UInt = #line) {
        let feed = uniqueRatesFeed().local
        let timestamp = Date()
        
        insert((feed, timestamp), to: sut)
        
        expect(sut, toRetrieveTwice: .success(CachedFeed(feed: feed, timestamp: timestamp)), file: file, line: line)
    }
    
    func assertThatInsertDeliversNoErrorOnEmptyCache(on sut: RatesFeedStore, file: StaticString = #file, line: UInt = #line) {
        let insertError = insert((uniqueRatesFeed().local, Date()), to: sut)
        
        XCTAssertNil(insertError, "Expected to insert cache successfully", file: file, line: line)
    }
    
    func assertThatInsertDeliversNoErrorOnNonEmptyCache(on sut: RatesFeedStore, file: StaticString = #file, line: UInt = #line) {
        insert((uniqueRatesFeed().local, Date()), to: sut)
        
        let insertError = insert((uniqueRatesFeed().local, Date()), to: sut)
        
        XCTAssertNil(insertError, "Expected to override cache successfully", file: file, line: line)
    }
    
    func assertThatInsertOverridesPreviouslyInsertedCacheValues(on sut: RatesFeedStore, file: StaticString = #file, line: UInt = #line) {
        insert((uniqueRatesFeed().local, Date()), to: sut)
        
        let latestFeed = uniqueRatesFeed().local
        let latestTimestamp = Date()
        insert((latestFeed, latestTimestamp), to: sut)
        
        expect(sut, toRetrieve: .success(CachedFeed(feed: latestFeed, timestamp: latestTimestamp)), file: file, line: line)
    }

    func assertThatDeleteDeliversNoErrorOnEmptyCache(on sut: RatesFeedStore, file: StaticString = #file, line: UInt = #line) {
        let deleteError = deleteCache(from: sut)
        
        XCTAssertNil(deleteError, "Expected empty cache delete to succeed", file: file, line: line)
    }
    
    func assertThatDeleteHasNoSideEffectsOnEmptyCache(on sut: RatesFeedStore, file: StaticString = #file, line: UInt = #line) {
        deleteCache(from: sut)
        
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }

    func assertThatDeleteDeliversNoErrorOnNonEmptyCache(on sut: RatesFeedStore, file: StaticString = #file, line: UInt = #line) {
        insert((uniqueRatesFeed().local, Date()), to: sut)
        
        let deleteError = deleteCache(from: sut)
        
        XCTAssertNil(deleteError, "Expected non-empty cache delete to succeed", file: file, line: line)
    }
    
    func assertThatDeleteEmptiesPreviouslyInsertedCache(on sut: RatesFeedStore, file: StaticString = #file, line: UInt = #line) {
        insert((uniqueRatesFeed().local, Date()), to: sut)
        
        deleteCache(from: sut)
        
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
    
    func assertThatSideEffectsRunSerially(on sut: RatesFeedStore, file: StaticString = #file, line: UInt = #line) {
        var completedOperationsInOrder = [XCTestExpectation]()
        
        let op1 = expectation(description: "Operation 1")
        sut.insert(uniqueRatesFeed().local, timestamp: Date()) { _ in
            completedOperationsInOrder.append(op1)
            op1.fulfill()
        }
        
        let op2 = expectation(description: "Operation 2")
        sut.deleteCachedFeed { _ in
            completedOperationsInOrder.append(op2)
            op2.fulfill()
        }
        
        let op3 = expectation(description: "Operation 3")
        sut.insert(uniqueRatesFeed().local, timestamp: Date()) { _ in
            completedOperationsInOrder.append(op3)
            op3.fulfill()
        }
        
        waitForExpectations(timeout: 5.0)
        
        XCTAssertEqual(completedOperationsInOrder, [op1, op2, op3], "Expected side-effects to run serially but operations finished in the wrong order", file: file, line: line)
    }

}

extension RatesFeedStoreSpecs where Self: XCTestCase {
    @discardableResult
    func insert(_ cache: (feed: [LocalFeedRate], timestamp: Date), to sut: RatesFeedStore) -> Error? {
        let exp = expectation(description: "Wait for cache insert")
        var insertError: Error?
        sut.insert(cache.feed, timestamp: cache.timestamp) { result in
            if case let Result.failure(error) = result { insertError = error }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return insertError
    }
    
    @discardableResult
    func deleteCache(from sut: RatesFeedStore) -> Error? {
        let exp = expectation(description: "Wait for cache delete")
        var deleteError: Error?
        sut.deleteCachedFeed { result in
            if case let Result.failure(error) = result { deleteError = error }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return deleteError
    }
    
    func expect(_ sut: RatesFeedStore, toRetrieveTwice expectedResult: RatesFeedStore.RetrieveResult, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }
    
    func expect(_ sut: RatesFeedStore, toRetrieve expectedResult: RatesFeedStore.RetrieveResult, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for cache retrieve")
        
        sut.retrieve { retrievedResult in
            switch (expectedResult, retrievedResult) {
            case (.success(.none), .success(.none)),
                 (.failure, .failure):
                break
                
            case let (.success(.some(expected)), .success(.some(retrieved))):
                XCTAssertEqual(retrieved.feed, expected.feed, file: file, line: line)
                XCTAssertEqual(retrieved.timestamp, expected.timestamp, file: file, line: line)
                
            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
}

