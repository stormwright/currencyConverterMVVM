//
//  LocalFeedRate.swift
//  MoneyConverterEngine
//
//  Created by Mikayil on 08/09/2020.
//  Copyright © 2020 Stormwright. All rights reserved.
//

import Foundation

public struct LocalFeedRate: Equatable {
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
