//
//  ReceiveViewModel.swift
//  POSMerchant
//
//  Created by Mederic Petit on 27/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

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

    func didTapCharacter(_ character: String) {
        self.processInput(character)
    }

    func didTapDelete() {
        self.displayAmount.removeLast()
        if self.displayAmount == "" {
            self.displayAmount = "0"
        }
    }

    private func processInput(_ character: String) {
        if self.displayAmount == "0" && character != NSLocale.current.decimalSeparator {
            guard character != "0" else { return }
            self.displayAmount = character
        } else {
            self.displayAmount.append(character)
        }
    }
}
