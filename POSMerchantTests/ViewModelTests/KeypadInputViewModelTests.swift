//
//  KeypadInputViewModelTests.swift
//  POSMerchantTests
//
//  Created by Mederic Petit on 26/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
@testable import POSMerchant
import XCTest

class KeypadInputViewModelTests: XCTestCase {
    var sut: KeypadInputViewModel!
    var tokenLoader: TestTokenLoader!
    var sessionManager: TestSessionManager!

    override func setUp() {
        super.setUp()
        self.sessionManager = TestSessionManager()
        self.tokenLoader = TestTokenLoader()
        self.sut = KeypadInputViewModel(tokenLoader: self.tokenLoader,
                                        sessionManager: self.sessionManager)
    }

    override func tearDown() {
        self.sessionManager = nil
        self.tokenLoader = nil
        self.sut = nil
        super.tearDown()
    }

    func testLoadsDefaultToken() {
        XCTAssertTrue(self.tokenLoader.isListCalled)
    }

    func testLoadDefaultTokenFailed() {
        var didFail = false
        let error: OMGError = .unexpected(message: "Failed to load default token")
        self.sut.onFailGetDefaultToken = {
            XCTAssertEqual($0.message, error.message)
            didFail = true
        }
        self.sut.loadDefaultToken()
        self.tokenLoader.failure(withError: error)
        XCTAssert(didFail)
    }

    func testLoadDefaultTokenSuccessWithTokens() {
        var tokenStr: String?
        self.sut.onTokenUpdate = {
            tokenStr = $0
        }
        let wallets = StubGenerator.wallets()
        let pagination = StubGenerator.pagination()
        self.sut.loadDefaultToken()
        self.tokenLoader.success(withAccount: wallets, pagination: pagination)
        XCTAssertEqual(tokenStr, wallets.first!.balances.first!.token.name)
    }

    func testLoadDefaultTokenSuccessWithoutToken() {
        var didFail = false
        self.sut.onFailGetDefaultToken = {
            XCTAssertEqual($0.message,
                           "keypad_input.error.no_token".localized())
            didFail = true
        }
        let pagination = StubGenerator.pagination()
        self.sut.loadDefaultToken()
        self.tokenLoader.success(withAccount: [], pagination: pagination)
        XCTAssertTrue(didFail)
    }

    func testTapValidNumberWhenDisplayAmountIs0() {
        self.sut.displayAmount = "0"
        var amount: String?
        self.sut.onAmountUpdate = {
            amount = $0
        }
        self.sut.didTapNumber("1")
        XCTAssertEqual(amount, "1")
    }

    func testTap0WhenDisplayAmountIs0() {
        let initialAmount = "0"
        self.sut.displayAmount = initialAmount
        self.sut.onAmountUpdate = { _ in
            XCTFail("should not be called")
        }
        self.sut.didTapNumber("0")
        XCTAssertEqual(self.sut.displayAmount, initialAmount)
    }

    func testTapNumberWhenDisplayAmountIsNot0() {
        self.sut.displayAmount = "1"
        var amount: String?
        self.sut.onAmountUpdate = {
            amount = $0
        }
        self.sut.didTapNumber("2")
        XCTAssertEqual(amount, "12")
    }

    func testTapDesimalSeparatorWhenNotContainingYet() {
        self.sut.displayAmount = "1"
        var amount: String?
        self.sut.onAmountUpdate = {
            amount = $0
        }
        let separator = Locale.current.decimalSeparator ?? "."
        self.sut.didTapDecimalSeparator(Character(separator))
        XCTAssertEqual(amount, "1\(separator)")
    }

    func testTapDesimalSeparatorWhenAlreadyContaining() {
        let separator = Locale.current.decimalSeparator ?? "."
        let initialAmount = "1\(separator)2"
        self.sut.displayAmount = initialAmount
        self.sut.onAmountUpdate = { _ in
            XCTFail("should not be called")
        }
        self.sut.didTapDecimalSeparator(Character(separator))
        XCTAssertEqual(self.sut.displayAmount, initialAmount)
    }

    func testTapDeleteWhenAmountIsNotGoingToBeEmpty() {
        self.sut.displayAmount = "123"
        var amount: String?
        self.sut.onAmountUpdate = {
            amount = $0
        }
        self.sut.didTapDelete()
        XCTAssertEqual(amount, "12")
    }

    func testTapDeleteWhenAmountIsGoingToBeEmpty() {
        self.sut.displayAmount = "1"
        var amount: String?
        self.sut.onAmountUpdate = {
            amount = $0
        }
        self.sut.didTapDelete()
        XCTAssertEqual(amount, "0")
    }

    func testDidSelectToken() {
        let expectedToken = StubGenerator.wallets().first!.balances.first!.token
        var tokenStr: String?
        self.sut.onTokenUpdate = {
            tokenStr = $0
        }
        self.sut.didSelectToken(expectedToken)
        XCTAssertEqual(tokenStr, expectedToken.name)
    }

    func testResetAmount() {
        self.sut.displayAmount = "123"
        var amount: String?
        self.sut.onAmountUpdate = {
            amount = $0
        }
        self.sut.resetAmount()
        XCTAssertEqual(amount, "0")
    }

    func testIsNotReadyWhenNoToken() {
        self.sut.selectedToken = nil
        XCTAssertFalse(self.sut.isReady)
    }

    func testOnReadyStateChangeIsTriggeredWhenSelectedTokenIsUpdated() {
        var ready = false
        self.sut.onReadyStateChange = {
            ready = $0
        }
        self.sut.selectedToken = StubGenerator.wallets().first!.balances.first!.token
        XCTAssertTrue(ready)
    }

    func testAmountIsNotValidWhen0() {
        self.sut.displayAmount = "0"
        XCTAssertFalse(self.sut.isAmountValid)
    }

    func testIsAmountValidCallbackIsTriggeredWhenAmountIsUpdated() {
        var isAmountValid = false
        self.sut.selectedToken = StubGenerator.wallets().first!.balances.first!.token
        self.sut.onAmountValidationChange = {
            isAmountValid = $0
        }
        self.sut.displayAmount = "1"
        XCTAssertTrue(isAmountValid)
    }
}
