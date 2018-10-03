//
//  TransactionResultViewModelProtocol.swift
//  POSMerchant
//
//  Created by Mederic Petit on 3/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

protocol TransactionResultViewModelProtocol {
    var status: String { get }
    var amountDisplay: String { get }
    var direction: String { get }
    var username: String { get }
    var userId: String { get }
    var error: String { get }
    var done: String { get }
}
