//
//  FeedCache.swift
//  MoneyConverterEngine
//
//  Copyright © 2020 Stormwright. All rights reserved.
//

import Foundation

public protocol FeedCache {
    typealias Result = Swift.Result<Void, Error>

    func save(_ feed: [FeedRate], completion: @escaping (Result) -> Void)
}
