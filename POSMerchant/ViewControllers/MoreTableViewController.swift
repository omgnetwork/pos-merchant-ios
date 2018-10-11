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
    let exchangeAccountsSegueIdentifier = "showExchangeAccountsViewController"
    let transactionsSegueIdentifier = "showTransactionsViewController"
    let touchIdConfirmationSegueIdentifier = "showTouchIdConfirmationViewController"

    @IBOutlet var transactionLabel: UILabel!
    @IBOutlet var accountLabel: UILabel!
    @IBOutlet var accountValueLabel: UILabel!
    @IBOutlet var exchangeAccountLabel: UILabel!
    @IBOutlet var exchangeAccountValueLabel: UILabel!
    @IBOutlet var touchFaceIdLabel: UILabel!
    @IBOutlet var touchFaceIdSwitch: UISwitch!
    @IBOutlet var signOutLabel: UILabel!
    @IBOutlet var versionLabel: UILabel!
    @IBOutlet var versionValueLabel: UILabel!

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
        self.exchangeAccountLabel.text = self.viewModel.exchangeAccountLabelText
        self.exchangeAccountValueLabel.text = self.viewModel.exchangeAccountValueLabelText
        self.touchFaceIdLabel.text = self.viewModel.touchFaceIdLabelText
        self.touchFaceIdSwitch.isOn = self.viewModel.switchState
        self.signOutLabel.text = self.viewModel.signOutLabelText
        self.versionLabel.text = self.viewModel.versionLabelText
        self.versionValueLabel.text = self.viewModel.currentVersion
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
        self.viewModel.onExchangeAccountUpdate = { [weak self] in
            self?.exchangeAccountValueLabel.text = self?.viewModel.exchangeAccountValueLabelText
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if segue.identifier == self.exchangeAccountsSegueIdentifier,
            let vc = segue.destination as? SelectAccountTableViewController {
            vc.viewModel = SelectAccountViewModel(mode: .exchangeAccount, delegate: self.viewModel)
        } else if segue.identifier == self.accountsSegueIdentifier,
            let vc = segue.destination as? SelectAccountTableViewController {
            vc.viewModel = SelectAccountViewModel(mode: .currentAccount, delegate: self.viewModel)
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
    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0, 0): // accounts
            self.performSegue(withIdentifier: self.accountsSegueIdentifier, sender: nil)
        case (0, 1): // exchange account
            self.performSegue(withIdentifier: self.exchangeAccountsSegueIdentifier, sender: nil)
        case (0, 2): // transactions
            self.performSegue(withIdentifier: self.transactionsSegueIdentifier, sender: nil)
        case (2, 0): // Sign out
            self.viewModel.logout()
        default:
            break
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (0, 2) where !self.viewModel.isBiometricAvailable: return 0
        default: return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }

    override func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return self.viewModel.settingsSectionTitle
        case 1: return self.viewModel.infoSectionTitle
        default:
            return nil
        }
    }
}
