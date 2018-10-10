//
//  TransactionConfirmationViewModelProtocol.swift
//  POSMerchant
//
//  Created by Mederic Petit on 2/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO

protocol TransactionConfirmationViewModelProtocol: WaitingForUserConfirmationViewControllerDelegate {
    var onSuccessGetTransactionRequest: SuccessClosure? { get set }
    var onFailGetTransactionRequest: FailureClosure? { get set }
    var onLoadStateChange: ObjectClosure<Bool>? { get set }
    var onCompletedConsumption: ObjectClosure<TransactionBuilder>? { get set }
    var onPendingConsumptionConfirmation: EmptyClosure? { get set }

    var title: String { get }
    var direction: String { get }
    var amountDisplay: String { get }
    var confirm: String { get }
    var cancel: String { get }
    var isReady: Bool { get }
    var username: String { get }
    var userId: String { get }
    var userExpectedAmountDisplay: String { get }

    init(sessionManager: SessionManagerProtocol,
         walletLoader: WalletLoaderProtocol,
         transactionConsumptionGenerator: TransactionConsumptionGeneratorProtocol,
         transactionBuilder: TransactionBuilder)

    func loadTransactionRequest()
    func performTransaction()
    func stopListening()
}
