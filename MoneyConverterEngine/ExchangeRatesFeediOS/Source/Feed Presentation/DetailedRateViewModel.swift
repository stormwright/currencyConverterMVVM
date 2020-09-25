//
// Copyright © 2020 Stormwright. All rights reserved.
//

import Foundation

final class DetailedRateViewModel {
    
    private let quoteCurrrency: String
    private let rate: String
    
    init(quoteCurrrency: String, rate: String) {
        self.quoteCurrrency = quoteCurrrency
        self.rate = rate
    }
    
    func load(completion: (String, String) -> Void) {
        completion(quoteCurrrency, rate)
    }
}
