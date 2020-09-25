//
// Copyright © 2020 Stormwright. All rights reserved.
//

import Foundation

public protocol Router {
    associatedtype Destination

    func route(to destination: Destination)
}
