//
//  MoreTableViewController.swift
//  POSMerchant
//
//  Created by Mederic Petit on 4/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

class MoreTableViewController: BaseTableViewController {
    let accountsSegueIdentifier = "showAccountsViewController"
    let transactionsSegueIdentifier = "showTransactionsViewController"
    let touchIdConfirmationSegueIdentifier = "showTouchIdConfirmationViewController"

    @IBOutlet var transactionLabel: UILabel!
    @IBOutlet var accountLabel: UILabel!
    @IBOutlet var accountValueLabel: UILabel!
    @IBOutlet var touchFaceIdLabel: UILabel!
    @IBOutlet var touchFaceIdSwitch: UISwitch!
    @IBOutlet var signOutLabel: UILabel!

    private var viewModel: MoreTableViewModelProtocol = MoreTableViewModel()

    class func initWithViewModel(_ viewModel: MoreTableViewModelProtocol = MoreTableViewModel()) -> MoreTableViewController? {
        guard let moreVC: MoreTableViewController = Storyboard.more.viewControllerFromId() else { return nil }
        moreVC.viewModel = viewModel
        return moreVC
    }

    override func configureView() {
        super.configureView()
        self.navigationItem.title = self.viewModel.title
        self.transactionLabel.text = self.viewModel.transactionLabelText
        self.accountLabel.text = self.viewModel.accountLabelText
        self.accountValueLabel.text = self.viewModel.accountValueLabelText
        self.touchFaceIdLabel.text = self.viewModel.touchFaceIdLabelText
        self.touchFaceIdSwitch.isOn = self.viewModel.switchState
        self.signOutLabel.text = self.viewModel.signOutLabelText
    }

    override func configureViewModel() {
        super.configureViewModel()
        self.viewModel.onFailLogout = { [weak self] in
            self?.showError(withMessage: $0.message)
        }
        self.viewModel.onLoadStateChange = { [weak self] in
            $0 ? self?.showLoading() : self?.hideLoading()
        }
        self.viewModel.shouldShowEnableConfirmationView = { [weak self] in
            guard let weakself = self else { return }
            weakself.performSegue(withIdentifier: weakself.touchIdConfirmationSegueIdentifier, sender: nil)
        }
        self.viewModel.onBioStateChange = { [weak self] isEnabled in
            self?.touchFaceIdSwitch.isOn = isEnabled
        }
        self.viewModel.onAccountUpdate = { [weak self] in
            self?.accountValueLabel.text = self?.viewModel.accountValueLabelText
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.touchFaceIdSwitch.isOn = self.viewModel.switchState
    }

    deinit {
        self.viewModel.stopObserving()
    }
}

extension MoreTableViewController {
    @IBAction func didUpdateSwitch(_ sender: UISwitch) {
        self.viewModel.toggleSwitch(newValue: sender.isOn)
    }
}

extension MoreTableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        switch (indexPath.section, indexPath.row) {
        case (1, 0) where !self.viewModel.isBiometricAvailable: // Email
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default: break
        }
        return cell
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0, 0): // accounts
            self.performSegue(withIdentifier: self.accountsSegueIdentifier, sender: nil)
        case (0, 1): // transactions
            self.performSegue(withIdentifier: self.transactionsSegueIdentifier, sender: nil)
        case (1, 0): // Sign out
            self.viewModel.logout()
        default:
            break
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (1, 1) where !self.viewModel.isBiometricAvailable: return 0
        default: return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
}
