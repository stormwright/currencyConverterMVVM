//
// Copyright © 2020 Stormwright. All rights reserved.
//

import UIKit

final class ExchangeRateCellController {
    
    private let viewModel: ExchangeRateCellViewModel<UIImage>
    private var cell: ExchangeRateCell?
    
    init(viewModel: ExchangeRateCellViewModel<UIImage>) {
        self.viewModel = viewModel
    }
    
    func view(in tableView: UITableView) -> UITableViewCell {
        let cell = bound(tableView.dequeueReusableCell())
        return cell
    }
    
    func cancelLoad() {
        releaseCellForReuse()
    }
    
    private func bound(_ cell: ExchangeRateCell) -> ExchangeRateCell {
        self.cell = cell
        cell.currencyCode.text = viewModel.currencyCode
        cell.currencyName.text = viewModel.currencyName
        cell.displayRoundedRate(originalRate: viewModel.exchangeRate)
        cell.loadFlag(for: viewModel.currencyCode)
        return cell
    }
    
    private func releaseCellForReuse() {
        cell = nil
    }
}
