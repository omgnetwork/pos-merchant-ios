//
//  TransactionResultViewModel.swift
//  POSMerchant
//
//  Created by Mederic Petit on 3/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO

class TransactionResultViewModel: BaseViewModel, TransactionResultViewModelProtocol {
    let status: String
    let amountDisplay: String
    let direction: String
    let username: String
    let userId: String
    let error: String
    let done: String
    let statusImage: UIImage
    let statusImageColor: UIColor

    private let transactionBuilder: TransactionBuilder

    init(transactionBuilder: TransactionBuilder) {
        self.transactionBuilder = transactionBuilder
        self.amountDisplay = "\(transactionBuilder.amount) \(transactionBuilder.token.symbol)"
        self.direction = transactionBuilder.type == .receive ?
            "transaction_result.from".localized() :
            "transaction_result.to".localized()
        self.username = transactionBuilder.user?.email ?? "-"
        self.userId = transactionBuilder.user?.id ?? "-"
        self.done = "transaction_result.done".localized()
        if let error = transactionBuilder.error {
            self.statusImage = UIImage(named: "Failed")!
            self.statusImageColor = Color.redError.uiColor()
            self.status = self.transactionBuilder.type == .receive ?
                "transaction_result.payment_failed".localized() :
                "transaction_result.topup_failed".localized()
            self.error = error.message
        } else {
            self.statusImage = UIImage(named: "Completed")!
            self.statusImageColor = Color.lightBlue.uiColor()
            self.status = self.transactionBuilder.type == .receive ?
                "transaction_result.payment_successful".localized() :
                "transaction_result.topup_successful".localized()
            self.error = ""
        }
    }
}
