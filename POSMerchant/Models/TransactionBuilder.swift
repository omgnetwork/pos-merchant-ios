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
    let address: String

    var user: User?
    var result: Response<Transaction>?

    init(type: TransactionType, amount: String, token: Token, address: String) {
        self.type = type
        self.amount = amount
        self.token = token
        self.address = address
    }

    func params(forAccount account: Account, idemPotencyToken: String) -> TransactionCreateParams {
        let formattedAmount = OMGNumberFormatter().number(from: self.amount,
                                                          subunitToUnit: self.token.subUnitToUnit)
        return TransactionCreateParams(fromAddress: self.type == .receive ? self.address : nil,
                                       toAddress: self.type == .topup ? self.address : nil,
                                       amount: formattedAmount,
                                       fromAmount: nil,
                                       toAmount: nil,
                                       fromTokenId: nil,
                                       toTokenId: nil,
                                       tokenId: self.token.id,
                                       fromAccountId: self.type == .topup ? account.id : nil,
                                       toAccountId: self.type == .receive ? account.id : nil,
                                       fromProviderUserId: nil,
                                       toProviderUserId: nil,
                                       fromUserId: nil,
                                       toUserId: nil,
                                       idempotencyToken: idemPotencyToken,
                                       exchangeAccountId: nil,
                                       exchangeAddress: nil,
                                       metadata: [:],
                                       encryptedMetadata: [:])
    }
}
