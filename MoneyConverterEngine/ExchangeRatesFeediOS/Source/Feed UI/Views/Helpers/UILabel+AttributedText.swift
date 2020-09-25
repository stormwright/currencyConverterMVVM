//
// Copyright © 2020 Stormwright. All rights reserved.
//

import UIKit

extension UILabel {
    
    func formatExchangeRate(originalRate: String, smallDigitsFontSize: CGFloat) -> NSAttributedString? {
        let quoteText = NSMutableAttributedString.init(string: originalRate)
        let firstIndex: String.Index = originalRate.startIndex
        let count = originalRate.count
        switch count {
        case 5:
            quoteText.setAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: smallDigitsFontSize)], range: NSMakeRange(4, originalRate.count-4))
        case 6:
            let point: Character = originalRate[originalRate.index(firstIndex, offsetBy: 2)]
            if point == "." {
                quoteText.setAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: smallDigitsFontSize)], range: NSMakeRange(5, originalRate.count-5))
            } else {
                quoteText.setAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: smallDigitsFontSize)], range: NSMakeRange(4, originalRate.count-4))
            }
        case 7:
            let point: Character = originalRate[originalRate.index(firstIndex, offsetBy: 3)]
            if point == "." {
                quoteText.setAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: smallDigitsFontSize)], range: NSMakeRange(6, originalRate.count-6))
            } else {
                quoteText.setAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: smallDigitsFontSize)], range: NSMakeRange(5, originalRate.count-5))
            }
        case 8:
            quoteText.setAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: smallDigitsFontSize)], range: NSMakeRange(6, originalRate.count-6))
        case 9:
            quoteText.setAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: smallDigitsFontSize)], range: NSMakeRange(7, originalRate.count-7))
        default:
            break
        }
        return quoteText
    }
}
