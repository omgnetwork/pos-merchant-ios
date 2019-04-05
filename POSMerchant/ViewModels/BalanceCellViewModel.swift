//
//  BalanceCellViewModel.swift
//  POSMerchant
//
//  Created by Mederic Petit on 28/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO

class BalanceCellViewModel: BaseViewModel {
    let balance: Balance!

    let name: String
    let shortName: String
    let displayAmount: String
    let isSelected: Bool

    init(balance: Balance, isSelected: Bool) {
        self.balance = balance
        self.name = balance.token.name
        self.shortName =
            balance.token.name.count <= 3 ?
            balance.token.name :
            balance.token.name.split(separator: " ").map { String($0.first ?? Character("")).uppercased() }.prefix(3).joined()
        self.displayAmount = balance.displayAmount(withPrecision: 2)
        self.isSelected = isSelected
    }
}
