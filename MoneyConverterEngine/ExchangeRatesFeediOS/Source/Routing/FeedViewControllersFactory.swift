//
// Copyright © 2020 Stormwright. All rights reserved.
//

import UIKit
import MoneyConverterEngine

public protocol FeedViewControllersFactory {
    func routeToDetailedRateView(quoteCurrency: String, rate: String) -> UIViewController
}
