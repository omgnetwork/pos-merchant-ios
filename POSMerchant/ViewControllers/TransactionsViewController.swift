//
//  TransactionsViewController.swift
//  POSMerchant
//
//  Created by Mederic Petit on 5/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

class TransactionsViewController: BaseTableViewController {
    private var viewModel: TransactionsViewModelProtocol = TransactionsViewModel()

    class func initWithViewModel(_ viewModel: TransactionsViewModelProtocol = TransactionsViewModel()) -> TransactionsViewController? {
        guard let transactionsVC: TransactionsViewController = Storyboard.more.viewControllerFromId() else { return nil }
        transactionsVC.viewModel = viewModel
        return transactionsVC
    }

    override func configureView() {
        super.configureView()
        self.title = self.viewModel.viewTitle
        self.refreshControl?.addTarget(self, action: #selector(self.reloadTransactions), for: .valueChanged)
        self.tableView.registerNib(tableViewCell: TransactionTableViewCell.self)
        self.tableView.rowHeight = 62
        self.tableView.estimatedRowHeight = 62
        self.tableView.refreshControl = self.refreshControl
        self.reloadTransactions()
    }

    override func configureViewModel() {
        super.configureViewModel()
        self.viewModel.onLoadStateChange = { [weak self] in
            self?.tableView.tableFooterView = $0 ? self?.loadingView : UIView()
        }
        self.viewModel.reloadTableViewClosure = { [weak self] in
            self?.tableView.reloadData()
            self?.refreshControl?.endRefreshing()
        }
        self.viewModel.onFailLoadTransactions = { [weak self] in
            self?.showError(withMessage: $0.localizedDescription)
            self?.refreshControl?.endRefreshing()
        }
        self.viewModel.appendNewResultClosure = { [weak self] indexPaths in
            UIView.setAnimationsEnabled(false)
            self?.tableView.insertRows(at: indexPaths, with: UITableView.RowAnimation.none)
            UIView.setAnimationsEnabled(true)
        }
    }

    @objc private func reloadTransactions() {
        self.viewModel.reloadTransactions()
    }
}

extension TransactionsViewController {
    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return self.viewModel.numberOfRow()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: TransactionTableViewCell = tableView.dequeueReusableCell(
            withIdentifier: TransactionTableViewCell.identifier(),
            for: indexPath
        ) as? TransactionTableViewCell else {
            return UITableViewCell()
        }
        cell.transactionCellViewModel = self.viewModel.transactionCellViewModel(at: indexPath)
        return cell
    }
}

extension TransactionsViewController {
    override func tableView(_: UITableView, willDisplay _: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.viewModel.shouldLoadNext(atIndexPath: indexPath) {
            self.viewModel.getNextTransactions()
        }
    }
}
