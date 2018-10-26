//
//  ReceiveViewModelTests.swift
//  POSMerchantTests
//
//  Created by Mederic Petit on 26/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import POSMerchant
import XCTest

class ReceiveViewModelTests: XCTestCase {
    var sut: ReceiveViewModel!
    var tokenLoader: TestTokenLoader!
    var sessionManager: TestSessionManager!

    override func setUp() {
        super.setUp()
        self.tokenLoader = TestTokenLoader()
        self.sessionManager = TestSessionManager()
        self.sut = ReceiveViewModel(tokenLoader: self.tokenLoader,
                                    sessionManager: self.sessionManager)
    }

    override func tearDown() {
        super.tearDown()
        self.sut = nil
        self.tokenLoader = nil
        self.sessionManager = nil
    }

    func testDecodeValidString() {
        var builder: TransactionBuilder?
        self.sut.shouldProcessTransaction = {
            builder = $0
        }
        self.sut.displayAmount = "12"
        let token = StubGenerator.wallets().first!.balances.first!.token
        self.sut.selectedToken = token
        self.sut.didDecode("123|456")
        XCTAssertEqual(builder!.type, .receive)
        XCTAssertEqual(builder!.amount, "12")
        XCTAssertEqual(builder!.token, token)
        XCTAssertEqual(builder!.transactionRequestFormattedId, "456")
    }

    func testDecodeInvalidString() {
        var error: POSMerchantError?
        self.sut.onInvalidQRCodeFormat = {
            error = $0
        }
        self.sut.displayAmount = "12"
        let token = StubGenerator.wallets().first!.balances.first!.token
        self.sut.selectedToken = token
        self.sut.didDecode("123")
        XCTAssertEqual(error?.message, "keypad_input.error.invalid_qr_code".localized())
    }
}
