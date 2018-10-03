//
//  TransactionResultViewController.swift
//  POSMerchant
//
//  Created by Mederic Petit on 3/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

class TransactionResultViewController: BaseViewController {
    var viewModel: TransactionResultViewModelProtocol!

    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var tokenLabel: UILabel!
    @IBOutlet var directionLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var userIdLabel: UILabel!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var errorLabel: UILabel!

    class func initWithViewModel(_ viewModel: TransactionResultViewModelProtocol) -> TransactionResultViewController? {
        guard let transactionResultVC: TransactionResultViewController =
            Storyboard.transaction.viewControllerFromId() else { return nil }
        transactionResultVC.viewModel = viewModel
        return transactionResultVC
    }

    override func configureView() {
        super.configureView()
        self.statusLabel.text = self.viewModel.status
        self.tokenLabel.text = self.viewModel.amountDisplay
        self.directionLabel.text = self.viewModel.direction
        self.usernameLabel.text = self.viewModel.username
        self.userIdLabel.text = self.viewModel.userId
        self.errorLabel.text = self.viewModel.error
        self.doneButton.setTitle(self.viewModel.done, for: .normal)
    }

    override func configureViewModel() {
        super.configureViewModel()
    }

    @IBAction func tapDoneButton(_: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
