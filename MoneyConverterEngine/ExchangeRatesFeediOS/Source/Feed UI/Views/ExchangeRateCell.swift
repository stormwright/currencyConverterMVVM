//
// Copyright © 2020 Stormwright. All rights reserved.
//

import UIKit

public final class ExchangeRateCell: UITableViewCell {
    
    @IBOutlet private(set) public var countryFlag: UIImageView!
    @IBOutlet private(set) public var currencyCode: UILabel!
    @IBOutlet private(set) public var currencyName: UILabel!
    @IBOutlet private(set) public var exchangeRate: UILabel!
    
    func displayRoundedRate(originalRate: String) {
        exchangeRate.attributedText = exchangeRate.formatExchangeRate(originalRate: originalRate, smallDigitsFontSize: 15)
    }
    
    func loadFlag(for key: String) {
        let bundle = Bundle(for: ExchangeRateCell.self)
        countryFlag.image = UIImage(named: key, in: bundle, compatibleWith: nil)
    }
    
}
