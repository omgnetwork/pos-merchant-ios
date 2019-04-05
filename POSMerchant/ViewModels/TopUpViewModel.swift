//
//  TopUpViewModel.swift
//  POSMerchant
//
//  Created by Mederic Petit on 4/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

class TopUpViewModel: KeypadInputViewModel {
    override var title: String {
        return "topup.label.title".localized()
    }

    override var buttonTitle: String {
        return "topup.button.action".localized()
    }

    override func didDecode(_ string: String) {
        guard let transactionBuilder = TransactionBuilder(type: .topup,
                                                          amount: self.displayAmount,
                                                          token: self.selectedToken!,
                                                          decodedString: string) else {
            self.onInvalidQRCodeFormat?(.message(message: "keypad_input.error.invalid_qr_code".localized()))
            return
        }
        self.shouldProcessTransaction?(transactionBuilder)
    }

    override func qrReaderStrings() -> (String, String) {
        let title = "\("qr_reader.label.scan_to".localized()) \("topup.label.title".localized().lowercased())"
        let tokenString = "\(self.displayAmount) \(self.selectedToken!.symbol)"
        return (title, tokenString)
    }
}
