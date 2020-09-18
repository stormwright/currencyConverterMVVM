//
// Copyright © 2020 Stormwright. all rights reserved.
// 

import MoneyConverterEngine

final class RatesFeedLoaderCacheDecorator: RatesFeedLoader {
    private let decoratee: RatesFeedLoader
    private let cache: FeedCache
    
    init(decoratee: RatesFeedLoader, cache: FeedCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    func load(completion: @escaping (RatesFeedLoader.Result) -> Void) {
        decoratee.load { [weak self] result in
            completion(result.map { feed in
                self?.cache.saveIgnoringResult(feed)
                return feed
            })
        }
    }
}

private extension FeedCache {
    func saveIgnoringResult(_ feed: [FeedRate]) {
        save(feed) { _ in }
    }
}



