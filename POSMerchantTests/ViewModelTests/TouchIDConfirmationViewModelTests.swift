//
//  TouchIDConfirmationViewModelTests.swift
//  POSMerchantTests
//
//  Created by Mederic Petit on 30/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
@testable import POSMerchant
import XCTest

class TouchIDConfirmationViewModelTests: XCTestCase {
    var sessionManager: TestSessionManager!
    var sut: TouchIDConfirmationViewModel!

    override func setUp() {
        super.setUp()
        self.sessionManager = TestSessionManager(isBiometricAvailable: true)
        self.sut = TouchIDConfirmationViewModel(sessionManager: self.sessionManager)
    }

    override func tearDown() {
        self.sessionManager = nil
        self.sut = nil
        super.tearDown()
    }

    func testInvalidPassword() {
        var passwordError: String?
        self.sut.updatePasswordValidation = { passwordError = $0 }
        self.sut.password = "2shor"
        XCTAssert(passwordError == "touch_id_confirmation.error.validation.password".localized())
    }

    func testValidPassword() {
        var passwordError: String?
        self.sut.updatePasswordValidation = { passwordError = $0 }
        self.fillValidCredentials()
        XCTAssert(passwordError == nil)
    }

    func testEnableBiometricAuthCalled() {
        self.fillValidCredentials()
        self.sut.enable()
        XCTAssert(self.sessionManager.enableBiometricAuthCalled)
    }

    func testEnableBiometricAuthSuccess() {
        var didSucceed = false
        self.fillValidCredentials()
        self.sut.onSuccessEnable = {
            didSucceed = true
        }
        self.sut.enable()
        self.sessionManager.enableBiometricAuthSuccss()
        XCTAssertTrue(didSucceed)
    }

    func testEnableBiometricAuthFailed() {
        var didFail = false
        self.fillValidCredentials()
        let error: OMGError = .unexpected(message: "Failed to enable biometric auth")
        self.sut.onFailedEnable = {
            XCTAssertEqual($0.message, error.message)
            didFail = true
        }
        self.sut.enable()
        self.sessionManager.enableBiometricAuthFailed(withError: error)
        XCTAssertTrue(didFail)
    }

    func testShowLoadingWhenEnabling() {
        var loadingStatus = false
        self.sut.onLoadStateChange = { loadingStatus = $0 }
        XCTAssertFalse(loadingStatus)
        self.fillValidCredentials()
        self.sut.enable()
        XCTAssertTrue(loadingStatus)
        self.sessionManager.enableBiometricAuthSuccss()
        XCTAssertFalse(loadingStatus)
    }

    private func fillValidCredentials() {
        self.sut.password = "aV@1IdP@ssWord"
    }
}
