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
}
