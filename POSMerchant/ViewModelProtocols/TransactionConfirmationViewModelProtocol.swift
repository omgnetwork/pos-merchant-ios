//
//  TransactionConfirmationViewModelProtocol.swift
//  POSMerchant
//
//  Created by Mederic Petit on 2/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO

protocol TransactionConfirmationViewModelProtocol {
    var onSuccessGetUser: SuccessClosure? { get set }
    var onFailGetUser: FailureClosure? { get set }
    var onLoadStateChange: ObjectClosure<Bool>? { get set }

    var title: String { get }
    var direction: String { get }
    var amountDisplay: String { get }
    var confirm: String { get }
    var cancel: String { get }
    var isReady: Bool { get set }
    var username: String { get set }
    var userId: String { get set }

    init(sessionManager: SessionManagerProtocol,
         walletLoader: WalletLoaderProtocol,
         transactionBuilder: TransactionBuilder)

    func loadUser()
}
