//
// Copyright © 2020 Stormwright. all rights reserved.
// 

import UIKit
import MoneyConverterEngine
import ExchangeRatesFeediOS

class AppViewControllerFactory {

    private let httpClient: HTTPClient
    private let localFeedLoader: LocalRatesFeedLoader
    
    init(httpClient: HTTPClient, localFeedLoader: LocalRatesFeedLoader) {
        self.httpClient = httpClient
        self.localFeedLoader = localFeedLoader
    }
    
    func routeToMainFeed() -> UIViewController {
        let url = URL(string: "https://pastebin.com/raw/gg4BAg5z")!
        let remoteRatesFeedLoader = RemoteRatesFeedLoader(url: url, client: httpClient)
        let navigationController = UINavigationController()
        let router = MainFeedRouter(navigationController: navigationController, factory: self)
        let view = MainFeedUIComposer.mainFeedComposedWith(
                ratesLoader: RatesFeedLoaderWithFallbackComposite(
                    primary: RatesFeedLoaderCacheDecorator(
                        decoratee: remoteRatesFeedLoader,
                        cache: localFeedLoader),
                    fallback: localFeedLoader),
                router: router)
        navigationController.setViewControllers([view], animated: true)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }
}

extension AppViewControllerFactory: FeedViewControllersFactory {
    
    func routeToDetailedRateView(quoteCurrency: String, rate: String) -> UIViewController {
        let view = DetailedRateViewUIComposer.datailedViewComposedWith(quoteCurrrency: quoteCurrency, rate: rate)
        return view
    }
}
