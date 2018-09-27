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
    private var viewModel: ReceiveViewModelProtocol = ReceiveViewModel()
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var tokenLabel: UILabel!
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
    }
}

extension ReceiveViewController {
    @IBAction func tapReceiveButton(_: UIButton) {
    }
}
