//
//  KeyboardViewController.swift
//  POSMerchant
//
//  Created by Mederic Petit on 27/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

class KeyboardViewController: BaseViewController {
    var viewModel: KeyboardViewModelProtocol = KeyboardViewModel()

    class func initWithViewModel(_ viewModel: KeyboardViewModelProtocol = KeyboardViewModel()) -> KeyboardViewController? {
        guard let keyboardVC: KeyboardViewController = Storyboard.keyboard.viewControllerFromId() else { return nil }
        keyboardVC.viewModel = viewModel
        return keyboardVC
    }

    @IBOutlet var decimalSeparatorButton: UIButton!

    override func configureView() {
        super.configureView()
    }

    @IBAction func didTapNumber(_ sender: UIButton) {
        self.viewModel.tapNumber(sender.tag)
    }

    @IBAction func didTapDecimalSeparatorButton(_: UIButton) {
        self.viewModel.tapDecimalSeparator()
    }

    @IBAction func didTapNumberButton(_: UIButton) {
        self.viewModel.tapDelete()
    }
}
