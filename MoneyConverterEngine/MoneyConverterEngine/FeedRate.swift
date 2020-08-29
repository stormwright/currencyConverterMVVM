//
//  FeedRate.swift
//  MoneyConverterEngine
//
//  Created by Mammadov, Mikayil (Proagrica) on 29/08/2020.
//  Copyright © 2020 Stormwright. All rights reserved.
//

import Foundation

public struct FeedRate: Equatable {
    let code: String
    let name: String
    let rate: Double
    let date: String
    let inverseRate: Double
    
    public init(code: String, name: String, rate: Double, date: String, inverseRate: Double) {
        self.code = code
        self.name = name
        self.rate = rate
        self.date = date
        self.inverseRate = inverseRate
    }
}
