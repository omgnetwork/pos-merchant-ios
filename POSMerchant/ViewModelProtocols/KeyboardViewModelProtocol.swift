//
//  KeyboardViewModelProtocol.swift
//  POSMerchant
//
//  Created by Mederic Petit on 27/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

protocol KeyboardViewModelProtocol {
    init(delegate: KeyboardEventDelegate?)
    func tapNumber(_ number: Int)
    func tapDecimalSeparator()
    func tapDelete()
}
