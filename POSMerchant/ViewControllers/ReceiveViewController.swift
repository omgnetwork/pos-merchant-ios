//
//  ReceiveViewController.swift
//  POSMerchant
//
//  Created by Mederic Petit on 27/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

class ReceiveViewController: BaseViewController {
    private let keyboardSegueId = "keyboardSegueIdentifier"
    private let selectTokenSegueId = "selectTokenSegueIdentifier"
    private let showScannerSegueId = "showScannerSegueIdentifier"
    private let showTransactionConfirmationSegueId = "showTransactionConfirmationSegueId"
    private var viewModel: ReceiveViewModelProtocol = ReceiveViewModel()
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var tokenLabel: UILabel!
    @IBOutlet var selectTokenButton: UIButton!
    @IBOutlet var receiveButton: UIButton!

    class func initWithViewModel(_ viewModel: ReceiveViewModelProtocol = ReceiveViewModel()) -> ReceiveViewController? {
        guard let receiveVC: ReceiveViewController = Storyboard.receive.viewControllerFromId() else { return nil }
        receiveVC.viewModel = viewModel
        return receiveVC
    }

    override func configureView() {
        super.configureView()
        self.titleLabel.text = self.viewModel.title
        self.amountLabel.text = self.viewModel.displayAmount
        self.tokenLabel.text = self.viewModel.tokenString
        self.receiveButton.setTitle(self.viewModel.receiveButtonTitle, for: .normal)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.keyboardSegueId,
            let keyboardVC: KeyboardViewController = segue.destination as? KeyboardViewController {
            keyboardVC.viewModel = KeyboardViewModel(delegate: self.viewModel)
        } else if segue.identifier == self.selectTokenSegueId,
            let selectTokenTableVC: SelectTokenTableViewController =
            (segue.destination as? BaseNavigationViewController)?.viewControllers.first as? SelectTokenTableViewController {
            selectTokenTableVC.viewModel =
                SelectTokenViewModel(delegate: self.viewModel,
                                     selectedToken: self.viewModel.selectedToken!)
        } else if segue.identifier == self.showScannerSegueId,
            let qrReaderVC: QRReaderViewController = segue.destination as? QRReaderViewController {
            let strings = self.viewModel.qrReaderStrings()
            qrReaderVC.viewModel = QRReaderViewModel(delegate: self.viewModel, title: strings.0, tokenString: strings.1)
        } else if segue.identifier == self.showTransactionConfirmationSegueId,
            let transactionConfirmationVC = segue.destination as? TransactionConfirmationViewController,
            let transactionBuilder = sender as? TransactionBuilder {
            transactionConfirmationVC.viewModel = TransactionConfirmationViewModel(transactionBuilder: transactionBuilder)
            self.viewModel.resetAmount()
        }
    }

    override func configureViewModel() {
        super.configureViewModel()
        self.viewModel.onAmountUpdate = { [weak self] in
            self?.amountLabel.text = $0
        }
        self.viewModel.onTokenUpdate = { [weak self] in
            self?.tokenLabel.text = $0
        }
        self.viewModel.onFailGetDefaultToken = { [weak self] in
            self?.showError(withMessage: $0.message)
        }
        self.viewModel.shouldProcessTransaction = { [weak self] transactionBuilder in
            guard let weakself = self else { return }
            weakself.dismiss(animated: true, completion: {
                weakself.performSegue(withIdentifier: weakself.showTransactionConfirmationSegueId,
                                      sender: transactionBuilder)
            })
        }
        self.viewModel.onReadyStateChange = { [weak self] in
            self?.selectTokenButton!.isEnabled = $0
            self?.selectTokenButton!.alpha = $0 ? 1 : 0.5
        }
        self.viewModel.onAmountValidationChange = { [weak self] in
            self?.receiveButton!.isEnabled = $0
            self?.receiveButton!.alpha = $0 ? 1 : 0.5
        }
    }
}

extension ReceiveViewController {
    @IBAction func tapSelectTokenButton(_: UIButton) {
        self.performSegue(withIdentifier: self.selectTokenSegueId, sender: nil)
    }

    @IBAction func tapReceiveButton(_: UIButton) {
        self.performSegue(withIdentifier: self.showScannerSegueId, sender: nil)
    }
}
