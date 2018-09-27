//
//  ReceiveViewModelProtocol.swift
//  POSMerchant
//
//  Created by Mederic Petit on 27/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

protocol ReceiveViewModelProtocol: KeyboardEventDelegate {
    var title: String { get }
    var receiveButtonTitle: String { get }
    var displayAmount: String { get set }
    var tokenString: String { get set }
    var onAmountUpdate: ObjectClosure<String>? { get set }
    var onTokenUpdate: ObjectClosure<String>? { get set }
}
