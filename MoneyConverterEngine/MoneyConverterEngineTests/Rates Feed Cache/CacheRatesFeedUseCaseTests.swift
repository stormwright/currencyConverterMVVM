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
    
    // MARK: - Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalRatesFeedLoader, store: RatesFeedStoreSpy) {
        let store = RatesFeedStoreSpy()
        let sut = LocalRatesFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
}

func uniqueFeedRateGBP() -> FeedRate {
    return FeedRate(code: "GBP", name: "British Pound Sterling", rate: 0.75783966587706, date: "Fri, 28 Aug 2020 00:00:01 GMT", inverseRate: 1.3195403263073)
}

func uniqueFeedRateEUR() -> FeedRate {
    return FeedRate(code: "EUR", name: "EURO", rate: 0.84665715551541, date: "Fri, 28 Aug 2020 00:00:01 GMT", inverseRate: 1.1811156304363)
}

func uniqueRatesFeed() -> (models: [FeedRate], local: [LocalFeedRate]) {
    let models = [uniqueFeedRateGBP(), uniqueFeedRateEUR()]
    let local = models.map { LocalFeedRate(code: $0.code, name: $0.name, rate: $0.rate, date: $0.date, inverseRate: $0.inverseRate) }
    return (models, local)
}

public struct LocalFeedRate: Equatable {
    public let code: String
    public let name: String
    public let rate: Double
    public let date: String
    public let inverseRate: Double
    
    public init(code: String, name: String, rate: Double, date: String, inverseRate: Double) {
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
    
    private var deletionCompletions = [DeleteCompletion]()
    private var insertionCompletions = [InsertCompletion]()
    private var retrievalCompletions = [RetrieveCompletion]()
    
    func deleteCachedFeed(completion: @escaping DeleteCompletion) {
        deletionCompletions.append(completion)
        receivedMessages.append(.deleteCachedFeed)
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

extension LocalRatesFeedLoader: FeedCache {
    
    typealias SaveResult = FeedCache.Result
    
    func save(_ feed: [FeedRate], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedFeed { (result) in
            
        }
    }

}

protocol FeedCache {
    typealias Result = Swift.Result<Void, Error>

    func save(_ feed: [FeedRate], completion: @escaping (Result) -> Void)
}
