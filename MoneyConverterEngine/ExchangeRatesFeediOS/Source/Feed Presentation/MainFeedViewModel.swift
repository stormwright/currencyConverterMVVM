//
// Copyright © 2020 Stormwright. All rights reserved.
//

import Foundation
import MoneyConverterEngine

final class MainFeedViewModel {
    
    typealias Observer<T> = (T) -> Void
    
    private var ratesFeedLoader: RatesFeedLoader?
    
    init(ratesFeedLoader: RatesFeedLoader) {
        self.ratesFeedLoader = ratesFeedLoader
    }
    
    var title: String {
        return NSLocalizedString("MAIN_VIEW_TITLE",
                                 tableName: "MainFeed",
                                 bundle: Bundle(for: MainFeedViewModel.self),
                                 comment: "Title for the main feed view")
    }
    
    
    var onLoadingStateChange: Observer<Bool>?
    var onRatesFeedLoad: Observer<[FeedRate]>?
    
    func load() {
        onLoadingStateChange?(true)
        ratesFeedLoader?.load(completion: { [weak self] (result) in
            if let feed = try? result.get() {
                self?.onRatesFeedLoad?(feed)
            } else {
                // error handling
            }
            self?.onLoadingStateChange?(false)
        })
    }
    
}
