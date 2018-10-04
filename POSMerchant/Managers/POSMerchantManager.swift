//
//  POSMerchantManager.swift
//  POSMerchant
//
//  Created by Mederic Petit on 25/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

class POSMerchantManager {
    static let shared: POSMerchantManager = POSMerchantManager()

    init() {
        Theme.apply()
    }
}
