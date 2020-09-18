//
// Copyright © 2020 Stormwright. all rights reserved.
// 

import MoneyConverterEngine

class RatesFeedLoaderWithFallbackComposite: RatesFeedLoader {
    private let primary: RatesFeedLoader
    private let fallback: RatesFeedLoader

    init(primary: RatesFeedLoader, fallback: RatesFeedLoader) {
        self.primary = primary
        self.fallback = fallback
    }
    
    func load(completion: @escaping (RatesFeedLoader.Result) -> Void) {
        primary.load { [weak self] result in
            switch result {
            case .success:
                completion(result)
            case .failure:
                self?.fallback.load(completion: completion)
            }
        }
    }
}
