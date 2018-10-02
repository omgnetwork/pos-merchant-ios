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

    func params(forAccount account: Account, idemPotencyToken: String) -> TransactionCreateParams {
        let formattedAmount = OMGNumberFormatter().number(from: self.amount,
                                                          subunitToUnit: self.token.subUnitToUnit)
        let params: TransactionCreateParams
        switch self.type {
        case .receive:
            params = TransactionCreateParams(fromAddress: self.address,
                                             toAddress: nil,
                                             amount: formattedAmount,
                                             fromAmount: nil,
                                             toAmount: nil,
                                             fromTokenId: nil,
                                             toTokenId: nil,
                                             tokenId: self.token.id,
                                             fromAccountId: nil,
                                             toAccountId: account.id,
                                             fromProviderUserId: nil,
                                             toProviderUserId: nil,
                                             fromUserId: nil,
                                             toUserId: nil,
                                             idempotencyToken: idemPotencyToken,
                                             exchangeAccountId: nil,
                                             exchangeAddress: nil,
                                             metadata: [:],
                                             encryptedMetadata: [:])
        case .topup:
            params = TransactionCreateParams(fromAddress: nil,
                                             toAddress: self.address,
                                             amount: formattedAmount,
                                             fromAmount: nil,
                                             toAmount: nil,
                                             fromTokenId: nil,
                                             toTokenId: nil,
                                             tokenId: self.token.id,
                                             fromAccountId: account.id,
                                             toAccountId: nil,
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
        return params
    }
}
