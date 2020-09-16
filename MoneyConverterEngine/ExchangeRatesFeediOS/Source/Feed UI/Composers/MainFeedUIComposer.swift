//
// Copyright © 2020 Stormwright. All rights reserved.
//

import UIKit
import MoneyConverterEngine

public final class MainFeedUIComposer {
    private init() {}
    
    static func mainFeedComposedWith(ratesLoader: RatesFeedLoader) -> MainFeedViewController {
        
        let viewModel = MainFeedViewModel(ratesFeedLoader: ratesLoader)
        
        let mainFeedController = MainFeedViewController.makeWith(viewModel: viewModel)
        
        viewModel.onRatesFeedLoad = adaptFeedToCellControllers(forwardingTo: mainFeedController)
        
        return mainFeedController
    }
    
    private static func adaptFeedToCellControllers(forwardingTo controller: MainFeedViewController) -> ([FeedRate]) -> Void {
        return { [weak controller] feed in
            controller?.tableModel = feed.map { model in
                ExchangeRateCellController(viewModel:
                    ExchangeRateCellViewModel(model: model, imageTransformer: UIImage.init))
            }
        }
    }
}

private extension MainFeedViewController {
    static func makeWith(viewModel: MainFeedViewModel) -> MainFeedViewController {
        let bundle = Bundle(for: MainFeedViewController.self)
        let storyboard = UIStoryboard(name: "MainFeed", bundle: bundle)
        let mainFeedController = storyboard.instantiateInitialViewController() as! MainFeedViewController
        mainFeedController.viewModel = viewModel
        mainFeedController.title = viewModel.title
        return mainFeedController
    }
}
