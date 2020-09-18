//
// Copyright © 2020 Stormwright. All rights reserved.
//

import Foundation

final class Localized {
    
    static var feedLoadError: String {
        return NSLocalizedString("FEED_VIEW_DISPLAY_ERROR",
             tableName: "MainFeed",
             bundle: Bundle(for: Localized.self),
             comment: "Error message displayed when we can't load the rates feed")
    }
}
