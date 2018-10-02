//
//  TransactionConfirmationViewController.swift
//  POSMerchant
//
//  Created by Mederic Petit on 2/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

class TransactionConfirmationViewController: BaseViewController {
    var viewModel: TransactionConfirmationViewModelProtocol!
    private let showSuccessSegueId = "showSuccess"
    private let showFailureSegueId = "showFailure"

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tokenLabel: UILabel!
    @IBOutlet var directionLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var userIdLabel: UILabel!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var cancelButton: UIButton!

    class func initWithViewModel(_ viewModel: TransactionConfirmationViewModelProtocol) -> TransactionConfirmationViewController? {
        guard let transactionConfirmationVC: TransactionConfirmationViewController =
            Storyboard.transaction.viewControllerFromId() else { return nil }
        transactionConfirmationVC.viewModel = viewModel
        return transactionConfirmationVC
    }

    override func configureView() {
        super.configureView()
        self.titleLabel.text = self.viewModel.title
        self.tokenLabel.text = self.viewModel.amountDisplay
        self.directionLabel.text = self.viewModel.direction
        self.usernameLabel.text = self.viewModel.username
        self.userIdLabel.text = self.viewModel.userId
        self.confirmButton.setTitle(self.viewModel.confirm, for: .normal)
        self.cancelButton.setTitle(self.viewModel.cancel, for: .normal)

        self.viewModel.loadUser()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.cancelButton.addBorder(withColor: Color.redError.uiColor(), width: 1, radius: 4)
    }

    override func configureViewModel() {
        super.configureViewModel()
        self.viewModel.onLoadStateChange = { [weak self] in
            $0 ? self?.showLoading() : self?.hideLoading()
        }
        self.viewModel.onSuccessGetUser = { [weak self] in
            self?.usernameLabel.text = self?.viewModel.username
            self?.userIdLabel.text = self?.viewModel.userId
            self?.updateButtonState()
        }
        self.viewModel.onFailGetUser = { [weak self] in
            self?.showError(withMessage: $0.localizedDescription)
        }
    }

    private func updateButtonState() {
        self.confirmButton.isEnabled = self.viewModel.isReady
        self.confirmButton.alpha = self.viewModel.isReady ? 1 : 0.5
    }
}

extension TransactionConfirmationViewController {
    @IBAction func tapConfirmButton(_: UIButton) {
    }

    @IBAction func tapCancelButton(_: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
