//
// Copyright © 2020 Stormwright. All rights reserved.
//

import Foundation
import MoneyConverterEngine

final class ExchangeRateCellViewModel<Image> {
    
    typealias Observer<T> = (T) -> Void
    private let model: FeedRate
    
    init(model: FeedRate) {
        self.model = model
    }
    
    var currencyCode: String {
        return model.code
    }
    
    var currencyName: String {
        return model.name
    }
    
    var exchangeRate: String {
        return String(format: "%f", model.rate)
    }
    
    var date: String {
        return model.date
    }
    
    var onImageLoad: Observer<Image>?
    
}
