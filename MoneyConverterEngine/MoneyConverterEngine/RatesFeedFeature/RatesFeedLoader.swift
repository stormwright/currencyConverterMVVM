//
//  RatesFeedLoader.swift
//  MoneyConverterEngine
//
//  Copyright © 2020 Stormwright. All rights reserved.
//

import Foundation

public protocol RatesFeedLoader {
    typealias Result = Swift.Result<[FeedRate], Error>
    
    func load(completion: @escaping (Result) -> Void)
}
