//
// Copyright © 2020 Stormwright. All rights reserved.
//

import CoreData

extension CoreDataRatesFeedStore: RatesFeedStore {
    
    public func deleteCachedFeed(completion: @escaping DeleteCompletion) {
        perform { context in
            completion(Result {
                try ManagedCache.find(in: context).map(context.delete).map(context.save)
            })
        }
    }
    
    public func insert(_ feed: [LocalFeedRate], timestamp: Date, completion: @escaping InsertCompletion) {
        perform { context in
            completion(Result {
                let managedCache = try ManagedCache.newUniqueInstance(in: context)
                managedCache.timestamp = timestamp
                managedCache.feed = ManagedRate.rates(from: feed, in: context)
                try context.save()
            })
        }
    }
    
    public func retrieve(completion: @escaping RetrieveCompletion) {
        perform { context in
            completion(Result {
                try ManagedCache.find(in: context).map {
                    CachedFeed(feed: $0.localFeed, timestamp: $0.timestamp)
                }
            })
        }
    }
}
