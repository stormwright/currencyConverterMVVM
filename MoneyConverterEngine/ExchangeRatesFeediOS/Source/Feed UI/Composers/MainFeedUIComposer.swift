//
// Copyright © 2020 Stormwright. All rights reserved.
//

import UIKit
import MoneyConverterEngine

public final class MainFeedUIComposer {
    private init() {}
    
    public static func mainFeedComposedWith(ratesLoader: RatesFeedLoader, router: MainFeedRouter) -> MainFeedViewController {
        
        let viewModel = MainFeedViewModel(ratesFeedLoader:
            MainQueueDispatchDecorator(decoratee: ratesLoader))
        
        let mainFeedController = MainFeedViewController.makeWith(viewModel: viewModel, router: router)
        viewModel.onRatesFeedLoad = adaptFeedToCellControllers(forwardingTo: mainFeedController)
        
        return mainFeedController
    }
    
    private static func adaptFeedToCellControllers(forwardingTo controller: MainFeedViewController) -> ([FeedRate]) -> Void {
        return { [weak controller] feed in
            controller?.tableModel = feed.map { model in
                ExchangeRateCellController(viewModel:
                    ExchangeRateCellViewModel(model: model))
            }
        }
    }
}

private extension MainFeedViewController {
    static func makeWith(viewModel: MainFeedViewModel, router: MainFeedRouter) -> MainFeedViewController {
        let bundle = Bundle(for: MainFeedViewController.self)
        let storyboard = UIStoryboard(name: "MainFeed", bundle: bundle)
        let mainFeedController = storyboard.instantiateInitialViewController() as! MainFeedViewController
        mainFeedController.viewModel = viewModel
        mainFeedController.title = viewModel.title
        mainFeedController.router = router
        return mainFeedController
    }
}
