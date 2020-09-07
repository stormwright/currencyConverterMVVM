//
//  RemoteRatesFeedLoader.swift
//  MoneyConverterEngine
//
//  Created by Mammadov, Mikayil (Proagrica) on 29/08/2020.
//  Copyright © 2020 Stormwright. All rights reserved.
//

import Foundation

public final class RemoteRatesFeedLoader: RatesFeedLoader {
   
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public typealias Result = RatesFeedLoader.Result
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] (result) in
            guard self != nil else { return }
            
            switch result {
            case let .success((data, response)):
                completion(RemoteRatesFeedLoader.map(data, from: response))
                
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try FeedRatesMapper.map(data, from: response)
            return .success(items.toModels())
        } catch {
            return .failure(error)
        }
    }
}

private extension Array where Element == RemoteFeedRate {
    func toModels() -> [FeedRate] {
        return map { FeedRate(code: $0.code, name: $0.name, rate: $0.rate, date: $0.date, inverseRate: $0.inverseRate) }
    }
}
