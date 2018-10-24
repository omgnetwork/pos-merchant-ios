//
//  TransactionBuilder.swift
//  POSMerchant
//
//  Created by Mederic Petit on 2/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO

struct TransactionBuilder {
    let type: TransactionType
    let amount: String
    let token: Token
    let transactionRequestFormattedId: String

    var user: User?
    var transactionConsumption: TransactionConsumption?
    var error: POSMerchantError?

    init?(type: TransactionType, amount: String, token: Token, decodedString: String) {
        let splittedIds = decodedString.split(separator: "|")
        guard splittedIds.count == 2 else { return nil }
        switch type {
        case .topup: self.transactionRequestFormattedId = String(splittedIds[0])
        case .receive: self.transactionRequestFormattedId = String(splittedIds[1])
        }
        self.type = type
        self.amount = amount
        self.token = token
    }

    func params(forAccount account: Account, idemPotencyToken: String) -> TransactionConsumptionParams {
        let formattedAmount = OMGNumberFormatter().number(from: self.amount,
                                                          subunitToUnit: self.token.subUnitToUnit)
        return TransactionConsumptionParams(formattedTransactionRequestId: self.transactionRequestFormattedId,
                                            accountId: account.id,
                                            amount: formattedAmount,
                                            idempotencyToken: idemPotencyToken,
                                            tokenId: self.token.id,
                                            exchangeAccountId: UserDefaultsWrapper().getValue(forKey: .exchangeAccountId))
    }
}
