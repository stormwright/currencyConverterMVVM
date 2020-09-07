//
//  FeedRate.swift
//  MoneyConverterEngine
//
//  Copyright © 2020 Stormwright. All rights reserved.
//

import Foundation

public struct FeedRate: Equatable {
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
