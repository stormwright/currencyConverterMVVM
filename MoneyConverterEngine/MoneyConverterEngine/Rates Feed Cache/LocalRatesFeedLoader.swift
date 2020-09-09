//
//  LocalRatesFeedLoader.swift
//  MoneyConverterEngine
//
//  Copyright © 2020 Stormwright. All rights reserved.
//

import Foundation

public class LocalRatesFeedLoader: RatesFeedLoader {
    
    private let store: RatesFeedStore
    private let currentDate: () -> Date
    
    public typealias LoadResult = RatesFeedLoader.Result
    
    public init(store: RatesFeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case let .failure(error):
                completion(.failure(error))

            case let .success(.some(cache)) where RatesFeedCachePolicy.validate(cache.timestamp, against: self.currentDate()):
                completion(.success(cache.feed.toModels()))
                
            case .success:
                completion(.success([]))
            }
        }
    }
}

extension LocalRatesFeedLoader: FeedCache {
    
    public typealias SaveResult = FeedCache.Result
    
    public func save(_ feed: [FeedRate], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedFeed { [weak self] (deleteResult) in
            guard let self = self else { return }
            
            switch deleteResult {
            case .success:
                self.cache(feed, with: completion)
            
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func cache(_ feed: [FeedRate], with completion: @escaping (SaveResult) -> Void) {
        store.insert(feed.toLocal(), timestamp: currentDate()) { [weak self] insertionResult in
            guard self != nil else { return }
            
            completion(insertionResult)
        }
    }
}

extension LocalRatesFeedLoader {
    public typealias ValidationResult = Result<Void, Error>

    public func validateCache(completion: @escaping (ValidationResult) -> Void) {
        store.retrieve { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure:
                self.store.deleteCachedFeed(completion: completion)
                
            case let .success(.some(cache)) where !RatesFeedCachePolicy.validate(cache.timestamp, against: self.currentDate()):
                self.store.deleteCachedFeed(completion: completion)
                
            case .success:
                completion(.success(()))
            }
        }
    }
}

private extension Array where Element == FeedRate {
    func toLocal() -> [LocalFeedRate] {
        return map { LocalFeedRate(code: $0.code, name: $0.name, rate: $0.rate, date: $0.date, inverseRate: $0.inverseRate) }
    }
}

private extension Array where Element == LocalFeedRate {
    func toModels() -> [FeedRate] {
        return map { FeedRate(code: $0.code, name: $0.name, rate: $0.rate, date: $0.date, inverseRate: $0.inverseRate) }
    }
}
