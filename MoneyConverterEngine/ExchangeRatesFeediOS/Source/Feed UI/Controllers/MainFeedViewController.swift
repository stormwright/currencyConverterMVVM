//
// Copyright © 2020 Stormwright. All rights reserved.
//

import UIKit

public final class MainFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.separatorStyle = .none
        }
    }
    
    @IBOutlet var errorView: ErrorView?
    
    var viewModel: MainFeedViewModel? {
        didSet {
            bind()
        }
    }
    
    var tableModel = [ExchangeRateCellController]() {
        didSet { tableView.reloadData() }
    }
    
    public override func viewDidLoad() {
        viewModel?.load()
    }
    
    private func bind() {
        viewModel?.onLoadingStateChange = { [weak self] isLoading in
            if isLoading {
                self?.errorView?.hideMessage()
            }            
        }
        
        viewModel?.onErrorLoad = { [weak self] errorMessage in
            self?.errorView?.show(message: errorMessage)
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view(in: tableView)
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> ExchangeRateCellController {
        return tableModel[indexPath.row]
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelCellControllerLoad(forRowAt: indexPath)
    }
    
    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
        cellController(forRowAt: indexPath).cancelLoad()
    }
  
}