//
//  FeedRatesMapper.swift
//  MoneyConverterEngine
//
//  Copyright © 2020 Stormwright. All rights reserved.
//

import Foundation

final class FeedRatesMapper {
    private struct Root: Decodable {
        let rates: [RemoteFeedRate]
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedRate] {
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteRatesFeedLoader.Error.invalidData
        }
        return root.rates
    }
}
