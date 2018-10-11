//
//  SelectAccountTableViewController.swift
//  POSMerchant
//
//  Created by Mederic Petit on 26/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

class SelectAccountTableViewController: BaseTableViewController {
    var viewModel: SelectAccountViewModelProtocol!

    class func initWithViewModel(_ viewModel: SelectAccountViewModelProtocol)
        -> SelectAccountTableViewController? {
        guard let transactionsVC: SelectAccountTableViewController = Storyboard.selectAccount.viewControllerFromId() else { return nil }
        transactionsVC.viewModel = viewModel
        return transactionsVC
    }

    override func configureView() {
        super.configureView()
        self.title = self.viewModel.viewTitle
        self.refreshControl?.addTarget(self, action: #selector(self.reloadAccounts), for: .valueChanged)
        self.tableView.registerNib(tableViewCell: AccountTableViewCell.self)
        self.tableView.rowHeight = 64
        self.tableView.estimatedRowHeight = 64
        self.tableView.refreshControl = self.refreshControl
        self.reloadAccounts()
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
        self.viewModel.onFailLoadAccounts = { [weak self] in
            self?.showError(withMessage: $0.localizedDescription)
            self?.refreshControl?.endRefreshing()
        }
        self.viewModel.appendNewResultClosure = { [weak self] indexPaths in
            UIView.setAnimationsEnabled(false)
            self?.tableView.insertRows(at: indexPaths, with: UITableView.RowAnimation.none)
            UIView.setAnimationsEnabled(true)
        }
    }

    @objc private func reloadAccounts() {
        self.viewModel.reloadAccounts()
    }
}

extension SelectAccountTableViewController {
    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return self.viewModel.numberOfRow()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: AccountTableViewCell = tableView.dequeueReusableCell(
            withIdentifier: AccountTableViewCell.identifier(),
            for: indexPath) as? AccountTableViewCell else {
            return UITableViewCell()
        }
        cell.accountCellViewModel = self.viewModel.accountCellViewModel(at: indexPath)
        return cell
    }
}

extension SelectAccountTableViewController {
    override func tableView(_: UITableView, willDisplay _: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.viewModel.shouldLoadNext(atIndexPath: indexPath) {
            self.viewModel.getNextAccounts()
        }
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.selectAccount(atIndexPath: indexPath)
    }
}
