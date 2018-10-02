//
//  Constant.swift
//  POSMerchant
//
//  Created by Mederic Petit on 25/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import Foundation

enum UserDefaultKey: String {
    case email = "com.omisego.pos-merchant.email"
    case biometricEnabled = "com.omisego.pos-merchant.biometric_enabled"
    case accountId = "com.omisego.pos-merchant.selected_account_id"
}

enum KeychainKey: String {
    case userId = "com.omisego.pos-merchant.user-id"
    case authenticationToken = "com.omisego.pos-merchant.authentication_token"
    case password = "com.omisego.pos-merchant.password"
}

struct Constant {
    static let urlScheme = "pos-merchant://"

    static let baseURL = "https://coffeego.omisego.io"

    // Pagination
    static let perPage = 20
}

enum TransactionType {
    case receive
    case topup
}
