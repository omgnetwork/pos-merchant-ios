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
    var displayAmount: String { get }
    var tokenString: String { get }
    var selectedToken: Token? { get }
    var onAmountUpdate: ObjectClosure<String>? { get set }
    var onTokenUpdate: ObjectClosure<String>? { get set }
    var onFailGetDefaultToken: FailureClosure? { get set }
    var onReadyStateChange: ObjectClosure<Bool>? { get set }
    var onAmountValidationChange: ObjectClosure<Bool>? { get set }
    var shouldProcessTransaction: ObjectClosure<TransactionBuilder>? { get set }
    func qrReaderStrings() -> (String, String)
    func resetAmount()
}
