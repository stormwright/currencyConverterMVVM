//
//  RatesFeedStore.swift
//  MoneyConverterEngine
//
//  Copyright © 2020 Stormwright. All rights reserved.
//

import Foundation

public typealias CachedFeed = (feed: [LocalFeedRate], timestamp: Date)

public protocol RatesFeedStore {
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
