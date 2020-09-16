//
// Copyright © 2020 Stormwright. All rights reserved.
//

import Foundation
import MoneyConverterEngine

final class ExchangeRateCellViewModel<Image> {
    
    typealias Observer<T> = (T) -> Void
    private let model: FeedRate
    private let imageTransformer: (Data) -> Image?
    
    init(model: FeedRate, imageTransformer: @escaping (Data) -> Image?) {
        self.model = model
        self.imageTransformer = imageTransformer
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
    
    func loadFlag() {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = model.code
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        if let imageData = try? imageTransformer(Data(contentsOf: fileURL)) {
            onImageLoad?(imageData)
        }
    }
}