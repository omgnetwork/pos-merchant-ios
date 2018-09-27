//
//  ReceiveViewModel.swift
//  POSMerchant
//
//  Created by Mederic Petit on 27/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
import UIKit

class ReceiveViewModel: BaseViewModel, ReceiveViewModelProtocol {
    let title: String = "receive.label.receive".localized()
    let receiveButtonTitle: String = "receive.button.receive".localized()
    var displayAmount: String {
        didSet {
            self.onAmountUpdate?(self.displayAmount)
        }
    }

    var tokenString: String

    var onAmountUpdate: ObjectClosure<String>?

    var onTokenUpdate: ObjectClosure<String>?

    override init() {
        self.displayAmount = "0"
        self.tokenString = "-"
        super.init()
    }

    func didTapNumber(_ number: String) {
        if self.displayAmount == "0" {
            if number == "0" { return }
            self.displayAmount = number
        } else {
            self.displayAmount.append(number)
        }
    }

    func didTapDecimalSeparator(_ character: Character) {
        guard !self.displayAmount.contains(character) else { return }
        self.displayAmount.append(character)
    }

    func didTapDelete() {
        var copiedAmount = self.displayAmount
        copiedAmount.removeLast()
        if copiedAmount == "" {
            copiedAmount = "0"
        }
        self.displayAmount = copiedAmount
    }
}
