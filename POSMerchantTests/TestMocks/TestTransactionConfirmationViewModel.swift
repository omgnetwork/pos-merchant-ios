//
//  TestTransactionConfirmationViewModel.swift
//  POSMerchantTests
//
//  Created by Mederic Petit on 29/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import POSMerchant
import UIKit

class TestTransactionConfirmationViewModel: TransactionConfirmationViewModelProtocol {
    var onSuccessGetTransactionRequest: SuccessClosure?
    var onFailGetTransactionRequest: FailureClosure?
    var onLoadStateChange: ObjectClosure<Bool>?
    var onCompletedConsumption: ObjectClosure<TransactionBuilder>?
    var onPendingConsumptionConfirmation: EmptyClosure?

    var title: String = "x"
    var direction: String = "x"
    var amountDisplay: String = "x"
    var confirm: String = "x"
    var cancel: String = "x"
    var isReady: Bool = false
    var username: String = "x"
    var userId: String = "x"
    var userExpectedAmountDisplay: String = "x"

    var loadTransactionRequestCalled = false
    var performTransactionCalled = false
    var stopListeningCalled = false
    var waitingForUserConfirmationDidCancelCalled = false

    func loadTransactionRequest() {
        self.loadTransactionRequestCalled = true
    }

    func performTransaction() {
        self.performTransactionCalled = true
    }

    func stopListening() {
        self.stopListeningCalled = true
    }

    func waitingForUserConfirmationDidCancel() {
        self.waitingForUserConfirmationDidCancelCalled = true
    }
}
