//
//  TransactionConfirmationViewModelTests.swift
//  POSMerchantTests
//
//  Created by Mederic Petit on 29/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
@testable import POSMerchant
import XCTest

class TransactionConfirmationViewModelTests: XCTestCase {
    var sut: TransactionConfirmationViewModel!
    var sessionManager: TestSessionManager!
    var walletLoader: TestWalletLoader!
    var transactionBuilder: TransactionBuilder!
    var transactionConsumptionGenerator: TestTransactionConsumptionGenerator!
    var transactionRequestGetter: TestTransactionRequestGetter!
    var transactionConsumptionRejector: TestTransactionConsumptionRejector!

    override func setUp() {
        super.setUp()
        self.sessionManager = TestSessionManager()
        self.sessionManager.selectedAccount = StubGenerator.accounts().first!
        self.walletLoader = TestWalletLoader()
        self.transactionConsumptionGenerator = TestTransactionConsumptionGenerator()
        self.transactionRequestGetter = TestTransactionRequestGetter()
        self.transactionConsumptionRejector = TestTransactionConsumptionRejector()
    }

    func setupWithReceive() {
        let token = StubGenerator.wallets().first!.balances.first!.token
        self.transactionBuilder = TransactionBuilder(type: .receive,
                                                     amount: "1",
                                                     token: token,
                                                     decodedString: "123|456")
        self.sut = TransactionConfirmationViewModel(sessionManager: self.sessionManager,
                                                    walletLoader: self.walletLoader,
                                                    transactionConsumptionGenerator: self.transactionConsumptionGenerator,
                                                    transactionBuilder: self.transactionBuilder,
                                                    transactionRequestGetter: self.transactionRequestGetter,
                                                    transactionConsumptionRejector: self.transactionConsumptionRejector)
    }

    func setupWithTopup() {
        let token = StubGenerator.wallets().first!.balances.first!.token
        self.transactionBuilder = TransactionBuilder(type: .topup,
                                                     amount: "1",
                                                     token: token,
                                                     decodedString: "123|456")
        self.sut = TransactionConfirmationViewModel(sessionManager: self.sessionManager,
                                                    walletLoader: self.walletLoader,
                                                    transactionConsumptionGenerator: self.transactionConsumptionGenerator,
                                                    transactionBuilder: self.transactionBuilder,
                                                    transactionRequestGetter: self.transactionRequestGetter,
                                                    transactionConsumptionRejector: self.transactionConsumptionRejector)
    }

    override func tearDown() {
        self.sut = nil
        self.sessionManager = nil
        self.walletLoader = nil
        self.transactionBuilder = nil
        self.transactionConsumptionGenerator = nil
        super.tearDown()
    }

    func testSetupReceive() {
        self.setupWithReceive()
        XCTAssertEqual(self.sut.amountDisplay, "1 TK1")
        XCTAssertEqual(self.sut.title, "transaction_confirmation.receive".localized())
        XCTAssertEqual(self.sut.direction, "transaction_confirmation.from".localized())
    }

    func testSetupTopup() {
        self.setupWithTopup()
        XCTAssertEqual(self.sut.amountDisplay, "1 TK1")
        XCTAssertEqual(self.sut.title, "transaction_confirmation.topup".localized())
        XCTAssertEqual(self.sut.direction, "transaction_confirmation.to".localized())
    }

    func testLoadTransactionRequestCalledWithCorrectIdWhenReceive() {
        self.setupWithReceive()
        self.sut.loadTransactionRequest()
        XCTAssertEqual(self.transactionRequestGetter.formattedId, "456")
    }

    func testLoadTransactionRequestCalledWithCorrectIdWhenTopup() {
        self.setupWithTopup()
        self.sut.loadTransactionRequest()
        XCTAssertEqual(self.transactionRequestGetter.formattedId, "123")
    }

    func testLoadTransactionRequestFailure() {
        self.setupWithReceive()
        var didFail = false
        self.sut.onFailGetTransactionRequest = {
            XCTAssertEqual($0.message, "transaction_confirmation.error.invalid_qr_code".localized())
            didFail = true
        }
        self.sut.loadTransactionRequest()
        self.transactionRequestGetter.getFailure()
        XCTAssertTrue(didFail)
    }

    func testLoadTransactionRequestSuccess() {
        self.setupWithReceive()
        let expectedRequest = StubGenerator.transactionRequest()
        var didSuccess = false
        self.sut.onSuccessGetTransactionRequest = {
            didSuccess = true
        }
        self.sut.loadTransactionRequest()
        self.transactionRequestGetter.getSuccess(withRequest: expectedRequest)
        XCTAssertTrue(didSuccess)
        XCTAssertTrue(self.sut.isReady)
        XCTAssertEqual(self.sut.username, "email@example.com")
        XCTAssertEqual(self.sut.userId, "usr_01cs9amcdf1kqp10de3q8fe56v")
    }

    func testShowLoadingWhenGettingRequest() {
        self.setupWithReceive()
        var loadingStatus = false
        self.sut.onLoadStateChange = { loadingStatus = $0 }
        XCTAssertFalse(loadingStatus)
        self.sut.loadTransactionRequest()
        XCTAssertTrue(loadingStatus)
        self.transactionRequestGetter.getSuccess(withRequest: StubGenerator.transactionRequest())
        XCTAssertFalse(loadingStatus)
    }

    func testPerformTransactionCalled() {
        self.setupWithReceive()
        self.sut.performTransaction()
        XCTAssertNotNil(self.transactionConsumptionGenerator.consumedCalledWithParams)
    }

    func testPerformTransactionFailure() {
        self.setupWithReceive()
        var builder: TransactionBuilder?
        let error = OMGError.unexpected(message: "fail")
        self.sut.onCompletedConsumption = {
            builder = $0
        }
        self.sut.performTransaction()
        self.transactionConsumptionGenerator.failure(withError: error)
        XCTAssertEqual(builder?.error?.message, "unexpected error: fail")
    }

    func testPerformTransactionSuccessWithConfirmation() {
        self.setupWithReceive()
        let consumption = StubGenerator.transactionConsumptionWithConfirmation()
        var success = false
        self.sut.onPendingConsumptionConfirmation = {
            success = true
        }
        self.sut.performTransaction()
        self.transactionConsumptionGenerator.success(withConsumption: consumption)
        XCTAssertTrue(success)
    }

    func testPerformTransactionSuccessWithoutConfirmation() {
        self.setupWithReceive()
        let consumption = StubGenerator.transactionConsumption()
        var builder: TransactionBuilder?
        self.sut.onCompletedConsumption = {
            builder = $0
        }
        self.sut.performTransaction()
        self.transactionConsumptionGenerator.success(withConsumption: consumption)
        XCTAssertEqual(builder?.transactionConsumption, consumption)
    }

    func testShowLoadingWhenPerformingTransaction() {
        self.setupWithReceive()
        var loadingStatus = false
        self.sut.onLoadStateChange = { loadingStatus = $0 }
        XCTAssertFalse(loadingStatus)
        self.sut.performTransaction()
        XCTAssertTrue(loadingStatus)
        self.transactionConsumptionGenerator.success(withConsumption: StubGenerator.transactionConsumption())
        XCTAssertFalse(loadingStatus)
    }

    func testCancelPendingConfirmation() {
        self.setupWithReceive()
        let consumption = StubGenerator.transactionConsumptionWithConfirmation()
        self.sut.performTransaction()
        self.transactionConsumptionGenerator.success(withConsumption: consumption)
        self.sut.waitingForUserConfirmationDidCancel()
        XCTAssertEqual(self.transactionConsumptionRejector.consumption, consumption)
    }

    func testOnSuccessfulConsumptionFinalized() {
        self.setupWithReceive()
        let consumption = StubGenerator.transactionConsumption()
        var builder: TransactionBuilder?
        self.sut.onCompletedConsumption = {
            builder = $0
        }
        self.sut.onSuccessfulTransactionConsumptionFinalized(consumption)
        XCTAssertEqual(builder?.transactionConsumption, consumption)
    }
}
