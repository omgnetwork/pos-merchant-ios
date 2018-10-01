//
//  ReceiveViewModelProtocol.swift
//  POSMerchant
//
//  Created by Mederic Petit on 27/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO

protocol ReceiveViewModelProtocol: KeyboardEventDelegate, SelectTokenDelegate, QRReaderDelegate {
    var title: String { get }
    var receiveButtonTitle: String { get }
    var displayAmount: String { get set }
    var tokenString: String { get set }
    var selectedToken: Token? { get set }
    var onAmountUpdate: ObjectClosure<String>? { get set }
    var onTokenUpdate: ObjectClosure<String>? { get set }
    var onFailGetDefaultToken: FailureClosure? { get set }
    var isReady: Bool { get }
    func qrReaderStrings() -> (String, String)
}
