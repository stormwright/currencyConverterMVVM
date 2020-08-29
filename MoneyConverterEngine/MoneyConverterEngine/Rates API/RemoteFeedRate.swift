//
//  RemoteFeedRate.swift
//  MoneyConverterEngine
//
//  Copyright © 2020 Stormwright. All rights reserved.
//

import Foundation

struct RemoteFeedRate: Decodable {
    let code: String
    let name: String
    let rate: Double
    let date: String
    let inverseRate: Double
}
