//
// Copyright © 2020 Stormwright. All rights reserved.
//

import UIKit

public final class DetailedRateViewUIComposer {
    private init() {}
    
    public static func datailedViewComposedWith(quoteCurrrency: String, rate: String) -> DetailedRateViewController {
        
        let viewModel = DetailedRateViewModel(quoteCurrrency: quoteCurrrency, rate: rate)
        
        let detailedViewController = DetailedRateViewController.makeWith(viewModel: viewModel)
        
        return detailedViewController
    }
}

private extension DetailedRateViewController {
    static func makeWith(viewModel: DetailedRateViewModel) -> DetailedRateViewController {
        let bundle = Bundle(for: MainFeedViewController.self)
        let storyboard = UIStoryboard(name: "DetailedView", bundle: bundle)
        let detailedView = storyboard.instantiateInitialViewController() as! DetailedRateViewController
        detailedView.viewModel = viewModel
        return detailedView
    }
}
