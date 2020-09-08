//
//  CacheRatesFeedUseCaseTests.swift
//  MoneyConverterEngineTests
//
//  Copyright © 2020 Stormwright. All rights reserved.
//

import XCTest
import MoneyConverterEngine

class CacheRatesFeedUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_save_requestsCacheDelete() {
        let (sut, store) = makeSUT()

        sut.save(uniqueRatesFeed().models) { _ in }

        XCTAssertEqual(store.receivedMessages, [.deleteCachedFeed])
    }
    
    func test_save_doesNotRequestCacheInsertOnDeleteError() {
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        
        sut.save(uniqueRatesFeed().models) { _ in }
        store.completeDelete(with: deletionError)
        
        XCTAssertEqual(store.receivedMessages, [.deleteCachedFeed])
    }
    
    func test_save_requestsNewCacheInsertWithTimestampOnSuccessfulDeleteOperation() {
        let timestamp = Date()
        let feed = uniqueRatesFeed()
        let (sut, store) = makeSUT(currentDate: { timestamp })
        
        sut.save(feed.models) { _ in }
        store.completeDeleteSuccessfully()
        
        XCTAssertEqual(store.receivedMessages, [.deleteCachedFeed, .insert(feed.local, timestamp)])
    }
    
    func test_save_failsOnDeleteError() {
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        
        expect(sut, toCompleteWithError: deletionError, when: {
            store.completeDelete(with: deletionError)
        })
    }
    
    func test_save_failsOnInsertError() {
        let (sut, store) = makeSUT()
        let insertionError = anyNSError()
        
        expect(sut, toCompleteWithError: insertionError, when: {
            store.completeDeleteSuccessfully()
            store.completeInsert(with: insertionError)
        })
    }
    
    func test_save_succeedsOnSuccessfulCacheInsert() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWithError: nil, when: {
            store.completeDeleteSuccessfully()
            store.completeInsertSuccessfully()
        })
    }
    
    func test_save_doesNotDeliverDeleteErrorAfterSUTInstanceHasBeenDeallocated() {
        let store = RatesFeedStoreSpy()
        var sut: LocalRatesFeedLoader? = LocalRatesFeedLoader(store: store, currentDate: Date.init)
        
        var receivedResults = [LocalRatesFeedLoader.SaveResult]()
        sut?.save(uniqueRatesFeed().models) { receivedResults.append($0) }
        
        sut = nil
        store.completeDelete(with: anyNSError())
        
        XCTAssertTrue(receivedResults.isEmpty)
    }
    
    func test_save_doesNotDeliverInsertErrorAfterSUTInstanceHasBeenDeallocated() {
        let store = RatesFeedStoreSpy()
        var sut: LocalRatesFeedLoader? = LocalRatesFeedLoader(store: store, currentDate: Date.init)
        
        var receivedResults = [LocalRatesFeedLoader.SaveResult]()
        sut?.save(uniqueRatesFeed().models) { receivedResults.append($0) }
        
        store.completeDeleteSuccessfully()
        sut = nil
        store.completeInsert(with: anyNSError())
        
        XCTAssertTrue(receivedResults.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalRatesFeedLoader, store: RatesFeedStoreSpy) {
        let store = RatesFeedStoreSpy()
        let sut = LocalRatesFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalRatesFeedLoader, toCompleteWithError expectedError: NSError?, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for save completion")
        
        var receivedError: Error?
        sut.save(uniqueRatesFeed().models) { result in
            if case let Result.failure(error) = result { receivedError = error }
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedError as NSError?, expectedError, file: file, line: line)
    }
    
}

