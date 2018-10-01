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

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if segue.identifier == self.keyboardSegueId,
            let keyboardVC: KeyboardViewController = segue.destination as? KeyboardViewController {
            keyboardVC.viewModel = KeyboardViewModel(delegate: self.viewModel)
        } else if segue.identifier == self.selectTokenSegueId,
            let selectTokenTableVC: SelectTokenTableViewController =
            (segue.destination as? BaseNavigationViewController)?.viewControllers.first as? SelectTokenTableViewController {
            selectTokenTableVC.viewModel =
                SelectTokenViewModel(delegate: self.viewModel,
                                     selectedToken: self.viewModel.selectedToken!)
        }
    }

    override func configureViewModel() {
        super.configureViewModel()
        self.viewModel.onAmountUpdate = { [weak self] in
            self?.amountLabel.text = $0
        }
        self.viewModel.onTokenUpdate = { [weak self] in
            self?.tokenLabel.text = $0
            self?.updateButtonsState()
        }
        self.viewModel.onFailGetDefaultToken = { [weak self] in
            self?.showError(withMessage: $0.message)
        }
    }

    private func updateButtonsState() {
        [self.receiveButton, self.selectTokenButton].forEach({
            $0!.isEnabled = self.viewModel.isReady
            $0!.alpha = self.viewModel.isReady ? 1 : 0.5
        })
    }
}

extension ReceiveViewController {
    @IBAction func tapSelectTokenButton(_: UIButton) {
        self.performSegue(withIdentifier: self.selectTokenSegueId, sender: nil)
    }

    @IBAction func tapReceiveButton(_: UIButton) {
    }
}
