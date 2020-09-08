//
//  SharedTestHelpers.swift
//  MoneyConverterEngineTests
//
//  Copyright © 2020 Stormwright. All rights reserved.
//

import Foundation
import MoneyConverterEngine

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyData() -> Data {
    return Data("any data".utf8)
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

extension Date {
    func minusFeedCacheMaxAge() -> Date {
        return adding(days: -feedCacheMaxAgeInDays)
    }
    
    private var feedCacheMaxAgeInDays: Int {
        return 7
    }
    
    private func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
}

extension Date {
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
