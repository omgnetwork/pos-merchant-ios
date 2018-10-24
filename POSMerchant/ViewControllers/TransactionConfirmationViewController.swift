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
    private let showTransactionResultSegueId = "showTransactionResultSegueIdentifier"
    private let showPendingConfirmationSegueId = "showPendingConfirmationSegueIdentifier"

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tokenLabel: UILabel!
    @IBOutlet var directionLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var userIdLabel: UILabel!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var userDisplayAmount: UILabel!

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
        self.confirmButton.isEnabled = self.viewModel.isReady
        self.confirmButton.alpha = self.viewModel.isReady ? 1 : 0.5
        self.userDisplayAmount.text = self.viewModel.userExpectedAmountDisplay

        self.viewModel.loadTransactionRequest()
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
        self.viewModel.onSuccessGetTransactionRequest = { [weak self] in
            self?.usernameLabel.text = self?.viewModel.username
            self?.userIdLabel.text = self?.viewModel.userId
            self?.userDisplayAmount.text = self?.viewModel.userExpectedAmountDisplay
            self?.updateButtonState()
        }
        self.viewModel.onFailGetTransactionRequest = { [weak self] in
            self?.showError(withMessage: $0.localizedDescription)
            self?.navigationController?.popViewController(animated: true)
        }
        self.viewModel.onPendingConsumptionConfirmation = { [weak self] in
            guard let weakself = self else { return }
            weakself.performSegue(withIdentifier: weakself.showPendingConfirmationSegueId, sender: nil)
        }
        self.viewModel.onCompletedConsumption = { [weak self] transactionBuilder in
            guard let weakself = self else { return }
            weakself.viewModel.stopListening()
            if let viewController = weakself.presentedViewController, !viewController.isBeingDismissed {
                viewController.dismiss(animated: true, completion: {
                    weakself.performSegue(withIdentifier: weakself.showTransactionResultSegueId, sender: transactionBuilder)
                })
            } else {
                weakself.performSegue(withIdentifier: weakself.showTransactionResultSegueId, sender: transactionBuilder)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.showTransactionResultSegueId,
            let transactionResultVC = segue.destination as? TransactionResultViewController,
            let transactionBuilder = sender as? TransactionBuilder {
            transactionResultVC.viewModel = TransactionResultViewModel(transactionBuilder: transactionBuilder)
        } else if segue.identifier == self.showPendingConfirmationSegueId,
            let vc = segue.destination as? WaitingForUserConfirmationViewController {
            vc.delegate = self.viewModel
        }
    }

    private func updateButtonState() {
        self.confirmButton.isEnabled = self.viewModel.isReady
        self.confirmButton.alpha = self.viewModel.isReady ? 1 : 0.5
    }
}

extension TransactionConfirmationViewController {
    @IBAction func tapConfirmButton(_: UIButton) {
        self.viewModel.performTransaction()
    }

    @IBAction func tapCancelButton(_: UIButton) {
        self.viewModel.stopListening()
        self.navigationController?.popViewController(animated: true)
    }
}
