//
// Copyright © 2020 Stormwright. All rights reserved.
//

import UIKit

public class DetailedRateViewController: UIViewController {
    
    @IBOutlet private(set) public var baseCurrencyFlag: UIImageView!
    @IBOutlet private(set) public var quoteCurrencyFlag: UIImageView!
    @IBOutlet private(set) public var exchangeRate: UILabel!
    
    var viewModel: DetailedRateViewModel?

    public override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }
    
    private func load() {
        viewModel?.load(completion: { (quoteCurrency, rate) in
            loadRate(originalRate: rate)
            loadQuoteCurrencyFlag(quoteCurrency: quoteCurrency)
            loadBaseCurrencyFlag(baseCurrency: "USD")
        })
    }
    
    private func loadRate(originalRate: String) {
        exchangeRate.attributedText = exchangeRate.formatExchangeRate(originalRate: originalRate, smallDigitsFontSize: 15)
    }
    
    private func loadQuoteCurrencyFlag(quoteCurrency: String) {
        let bundle = Bundle(for: ExchangeRateCell.self)
        quoteCurrencyFlag.image = UIImage(named: quoteCurrency, in: bundle, compatibleWith: nil)
    }
    
    private func loadBaseCurrencyFlag(baseCurrency: String) {
        let bundle = Bundle(for: ExchangeRateCell.self)
        baseCurrencyFlag.image = UIImage(named: baseCurrency, in: bundle, compatibleWith: nil)
    }

}
