//
// Copyright © 2020 Stormwright. All rights reserved.
//

import UIKit
import MoneyConverterEngine

public final class MainFeedRouter: Router {    

    public enum Destination {
        case detailedRate(quoteCurrency: String, rate: String)
    }
    
    private let factory: FeedViewControllersFactory
    
    private weak var navigationController: UINavigationController?
    
    public init(navigationController: UINavigationController, factory: FeedViewControllersFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    public func route(to destination: Destination) {
        switch destination {
        case .detailedRate(let quoteCurrency, let rate):
            let viewController = factory.routeToDetailedRateView(quoteCurrency: quoteCurrency, rate: rate)
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
