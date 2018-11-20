//
//  LoadingViewModelTests.swift
//  POSMerchantTests
//
//  Created by Mederic Petit on 22/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO
@testable import POSMerchant
import XCTest

class LoadingViewModelTests: XCTestCase {
    var sessionManager: TestSessionManager!
    var sut: LoadingViewModel!

    override func setUp() {
        super.setUp()
        self.sessionManager = TestSessionManager()
        self.sut = LoadingViewModel(sessionManager: self.sessionManager)
    }

    override func tearDown() {
        self.sessionManager = nil
        self.sut = nil
        super.tearDown()
    }

    func testLoadCalled() {
        self.sut.load()
        XCTAssertTrue(self.sessionManager.loadCurrentAccountCalled)
    }

    func testLoadCurrentAccountFailed() {
        var didFail = false
        var error: POSMerchantError?
        self.sut.onFailedLoading = {
            error = $0
            didFail = true
        }
        self.sut.load()
        let expectedError: OMGError = .unexpected(message: "Failed to load account")
        self.sessionManager.loadCurrentAccountFailure(withError: expectedError)
        XCTAssertNotNil(error)
        XCTAssertEqual(error!.message, expectedError.message)
        XCTAssert(didFail)
    }

    func testCallsForceLogoutWhenRaisingAnAuthenticationError() {
        let expectation = self.expectation(description: "Failure with an authentication error calls clearToken")
        self.sut.onFailedLoading = { _ in expectation.fulfill() }
        self.sut.load()
        let apiError = APIError(code: .authenticationTokenExpired, description: "")
        XCTAssertTrue(apiError.isAuthorizationError())
        let error: OMGError = .api(apiError: apiError)
        self.sessionManager.loadCurrentAccountFailure(withError: error)
        self.waitForExpectations(timeout: 1, handler: nil)
        XCTAssertTrue(self.sessionManager.logoutCalled)
        XCTAssertTrue(self.sessionManager.isForceLogout)
    }

    func testHideLoadingWhenRequestFails() {
        let expectation = self.expectation(description: "Hides loading when request fails")
        var loadingStatus = false
        self.sut.onLoadStateChange = {
            loadingStatus = $0
            if !loadingStatus { expectation.fulfill() }
        }
        self.sut.load()
        XCTAssertTrue(loadingStatus)
        self.sessionManager.loadCurrentAccountFailure(withError: .unexpected(message: ""))
        self.waitForExpectations(timeout: 1, handler: nil)
        XCTAssertFalse(loadingStatus)
    }
}
