//
//  TransactionCellViewModel.swift
//  POSMerchant
//
//  Created by Mederic Petit on 5/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import BigInt
import OmiseGO

class TransactionCellViewModel: BaseViewModel {
    private let transaction: Transaction!

    let name: String
    let timeStamp: String
    let amount: String
    let color: UIColor
    let statusText: String
    let statusImage: UIImage?

    init(transaction: Transaction, currentAccount: Account) {
        self.transaction = transaction
        var source: TransactionSource!
        let sign: String
        let defaultAddress = "transactions.label.genesis".localized()
        if currentAccount == transaction.from.account {
            self.color = Color.redError.uiColor()
            self.name = transaction.to.user?.email ?? transaction.to.account?.name ?? defaultAddress
            source = transaction.from
            sign = "-"
        } else if currentAccount == transaction.to.account {
            self.color = Color.transactionCreditGreen.uiColor()
            self.name = transaction.from.user?.email ?? transaction.from.account?.name ?? defaultAddress
            source = transaction.to
            sign = "+"
        } else {
            self.color = Color.greyUnderline.uiColor()
            let from = transaction.from.user?.email ?? transaction.from.account?.name ?? defaultAddress
            let to = transaction.to.user?.email ?? transaction.to.account?.name ?? defaultAddress
            self.name = "\(from) > \(to)"
            source = transaction.to
            sign = ""
        }
        switch transaction.status {
        case .confirmed:
            self.statusImage = UIImage(named: "checkmark_icon")
            self.statusText = "transactions.label.status.success".localized()
        default:
            self.statusImage = UIImage(named: "cross_icon")
            self.statusText = "transactions.label.status.failure".localized()
        }
        let displayableAmount = OMGNumberFormatter(precision: 2).string(from: source.amount, subunitToUnit: source.token.subUnitToUnit)
        amount = "\(sign) \(displayableAmount) \(source.token.symbol)"
        timeStamp = transaction.createdAt.toString(withFormat: "MMM dd, HH:mm")
    }
}
