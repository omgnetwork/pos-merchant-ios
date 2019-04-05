//
//  SelectTokenTableViewController.swift
//  POSMerchant
//
//  Created by Mederic Petit on 28/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

class SelectTokenTableViewController: BaseTableViewController {
    var viewModel: SelectTokenViewModelProtocol!

    class func initWithViewModel(_ viewModel: SelectTokenViewModelProtocol)
        -> SelectTokenTableViewController? {
        guard let selectTokenVC: SelectTokenTableViewController = Storyboard.selectToken.viewControllerFromId() else { return nil }
        selectTokenVC.viewModel = viewModel
        return selectTokenVC
    }

    override func configureView() {
        super.configureView()
        self.title = self.viewModel.viewTitle
        self.refreshControl?.addTarget(self, action: #selector(self.reloadTokens), for: .valueChanged)
        self.refreshControl?.tintColor = .white
        self.tableView.registerNib(tableViewCell: BalanceTableViewCell.self)
        self.tableView.rowHeight = 64
        self.tableView.estimatedRowHeight = 64
        self.tableView.refreshControl = self.refreshControl
        self.tableView.backgroundColor = Color.omiseGOBlue.uiColor()
        self.navigationController?.navigationBar.largeTitleTextAttributes = [
            .font: Font.avenirMedium.withSize(34),
            .foregroundColor: UIColor.white
        ]
        self.navigationController?.navigationBar.barTintColor = Color.omiseGOBlue.uiColor()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [
            .font: Font.avenirMedium.withSize(20),
            .foregroundColor: UIColor.white
        ]
        self.reloadTokens()
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
        self.viewModel.onFailLoadTokens = { [weak self] in
            self?.showError(withMessage: $0.localizedDescription)
            self?.refreshControl?.endRefreshing()
        }
    }

    @objc private func reloadTokens() {
        self.viewModel.loadBalances()
    }
}

extension SelectTokenTableViewController {
    @IBAction func tapCloseButton(_: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SelectTokenTableViewController {
    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return self.viewModel.numberOfRow()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: BalanceTableViewCell = tableView.dequeueReusableCell(
            withIdentifier: BalanceTableViewCell.identifier(),
            for: indexPath
        ) as? BalanceTableViewCell else {
            return UITableViewCell()
        }
        cell.balanceCellViewModel = self.viewModel.tokenCellViewModel(at: indexPath)
        return cell
    }
}

extension SelectTokenTableViewController {
    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.selectToken(atIndexPath: indexPath)
        dispatchMain {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
