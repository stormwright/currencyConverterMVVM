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
    
    // MARK: - Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalRatesFeedLoader, store: RatesFeedStoreSpy) {
        let store = RatesFeedStoreSpy()
        let sut = LocalRatesFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
}

struct LocalFeedRate: Equatable {
    let code: String
    let name: String
    let rate: Double
    let date: String
    let inverseRate: Double
    
    init(code: String, name: String, rate: Double, date: String, inverseRate: Double) {
        self.code = code
        self.name = name
        self.rate = rate
        self.date = date
        self.inverseRate = inverseRate
    }
}


typealias CachedFeed = (feed: [LocalFeedRate], timestamp: Date)

protocol RatesFeedStore {
    typealias DeleteResult = Result<Void, Error>
    typealias DeleteCompletion = (DeleteResult) -> Void
    
    typealias InsertResult = Result<Void, Error>
    typealias InsertCompletion = (InsertResult) -> Void
    
    typealias RetrieveResult = Result<CachedFeed?, Error>
    typealias RetrieveCompletion = (RetrieveResult) -> Void

    func deleteCachedFeed(completion: @escaping DeleteCompletion)
    
    func insert(_ feed: [LocalFeedRate], timestamp: Date, completion: @escaping InsertCompletion)
    
    func retrieve(completion: @escaping RetrieveCompletion)
}

class RatesFeedStoreSpy: RatesFeedStore {
    
    enum ReceivedMessage: Equatable {
        case deleteCachedFeed
        case insert([LocalFeedRate], Date)
        case retrieve
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    
    
    func deleteCachedFeed(completion: @escaping DeleteCompletion) {
        
    }
    
    func insert(_ feed: [LocalFeedRate], timestamp: Date, completion: @escaping InsertCompletion) {
        
    }
    
    func retrieve(completion: @escaping RetrieveCompletion) {
        
    }
    

}

class LocalRatesFeedLoader: RatesFeedLoader {
    
    private let store: RatesFeedStore
    private let currentDate: () -> Date
    
    typealias LoadResult = RatesFeedLoader.Result
    
    init(store: RatesFeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    func load(completion: @escaping (LoadResult) -> Void) {
        
    }
 
}
