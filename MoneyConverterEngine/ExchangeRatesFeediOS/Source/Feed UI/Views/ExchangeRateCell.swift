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
        let quoteText = NSMutableAttributedString.init(string: originalRate)
        let firstIndex: String.Index = originalRate.startIndex
        let count = originalRate.count
        switch count {
        case 5:
            quoteText.setAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], range: NSMakeRange(4, originalRate.count-4))
        case 6:
            let point: Character = originalRate[originalRate.index(firstIndex, offsetBy: 2)]
            if point == "." {
                quoteText.setAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], range: NSMakeRange(5, originalRate.count-5))
            } else {
                quoteText.setAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], range: NSMakeRange(4, originalRate.count-4))
            }
        case 7:
            let point: Character = originalRate[originalRate.index(firstIndex, offsetBy: 3)]
            if point == "." {
                quoteText.setAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], range: NSMakeRange(6, originalRate.count-6))
            } else {
                quoteText.setAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], range: NSMakeRange(5, originalRate.count-5))
            }
        case 8:
            quoteText.setAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], range: NSMakeRange(6, originalRate.count-6))
        case 9:
            quoteText.setAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], range: NSMakeRange(7, originalRate.count-7))
        default:
            break
        }
        exchangeRate.attributedText = quoteText
    }
    
    func loadFlag(for key: String) {
        let bundle = Bundle(for: ExchangeRateCell.self)
        countryFlag.image = UIImage(named: key, in: bundle, compatibleWith: nil)
    }
    
}
