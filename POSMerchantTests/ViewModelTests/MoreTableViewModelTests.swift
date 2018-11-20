//
//  MoreTableViewModelTests.swift
//  POSMerchantTests
//
//  Created by Mederic Petit on 29/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
@testable import POSMerchant
import XCTest

class MoreTableViewModelTests: XCTestCase {
    var sessionManager: TestSessionManager!
    var sut: MoreTableViewModel!

    override func setUp() {
        super.setUp()
        self.sessionManager = TestSessionManager(isBiometricAvailable: true)
        self.sut = MoreTableViewModel(sessionManager: self.sessionManager)
    }

    override func tearDown() {
        self.sessionManager = nil
        self.sut = nil
        super.tearDown()
    }

    func testSwitchStateIsInitializedCorrectly() {
        let sessionManager = TestSessionManager(isBiometricAvailable: true)
        let sut = MoreTableViewModel(sessionManager: sessionManager)
        XCTAssertTrue(sut.switchState)

        let sessionManager1 = TestSessionManager(isBiometricAvailable: false)
        let sut1 = MoreTableViewModel(sessionManager: sessionManager1)
        XCTAssertFalse(sut1.switchState)
    }

    func testSwitchStateUpdatesCallOnBioStateChange() {
        var onBioStateChangeCalled = false
        var switchState: Bool?
        self.sut.onBioStateChange = { swSt in
            onBioStateChangeCalled = true
            switchState = swSt
        }
        self.sut.switchState = true
        XCTAssertTrue(onBioStateChangeCalled)
        XCTAssertNotNil(switchState)
        XCTAssertTrue(switchState!)
    }

    func testToggleSwitchOnCallsShouldShowEnableConfirmationView() {
        var shouldShowEnableConfirmationViewCalled = false
        self.sut.shouldShowEnableConfirmationView = {
            shouldShowEnableConfirmationViewCalled = true
        }
        self.sut.toggleSwitch(newValue: true)
        XCTAssertTrue(shouldShowEnableConfirmationViewCalled)
    }

    func testToggleSwitchOffCallsOnDisableBiometricAuth() {
        self.sut.toggleSwitch(newValue: false)
        XCTAssertTrue(self.sessionManager.disableBiometricAuthCalled)
    }

    func testShowLoadingWhenLoggingOut() {
        var loadingStatus = false
        self.sut.onLoadStateChange = { loadingStatus = $0 }
        XCTAssertFalse(loadingStatus)
        self.sut.logout()
        XCTAssertTrue(loadingStatus)
        self.sessionManager.logoutFailure(withError: .unexpected(message: ""))
        XCTAssertFalse(loadingStatus)
    }

    func testLogoutCalled() {
        self.sut.logout()
        XCTAssert(self.sessionManager.logoutCalled)
    }

    func testLogoutFailed() {
        var didFail = false
        let error: OMGError = .unexpected(message: "Failed to logout")
        self.sut.onFailLogout = {
            XCTAssertEqual($0.message, error.message)
            didFail = true
        }
        self.sut.logout()
        self.sessionManager.logoutFailure(withError: error)
        XCTAssert(didFail)
    }

    func testBioStateUpdateTriggersSwitchStateChange() {
        self.sessionManager.notify(event: .onBioStateUpdate(enabled: true))
        XCTAssertTrue(self.sut.switchState)
        self.sessionManager.notify(event: .onBioStateUpdate(enabled: false))
        XCTAssertFalse(self.sut.switchState)
    }

    func testSelectExchangeAccount() {
        let account = StubGenerator.accounts().first!
        var didCall = false
        self.sut.onExchangeAccountUpdate = {
            didCall = true
        }
        self.sut.didSelectAccount(account: account, forMode: .exchangeAccount)
        XCTAssertEqual(self.sut.exchangeAccountValueLabelText, "Headquarter")
        XCTAssertTrue(didCall)
    }

    func testSelectCurrentAccount() {
        let account = StubGenerator.accounts().first!
        self.sessionManager.selectedAccount = account
        var didCall = false
        self.sut.onAccountUpdate = {
            didCall = true
        }
        self.sut.didSelectAccount(account: account, forMode: .currentAccount)
        XCTAssertEqual(self.sut.accountValueLabelText, "Headquarter")
        XCTAssertTrue(didCall)
    }
}
