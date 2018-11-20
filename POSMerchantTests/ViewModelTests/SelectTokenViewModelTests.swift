//
//  SelectTokenViewModelTests.swift
//  POSMerchantTests
//
//  Created by Mederic Petit on 26/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
@testable import POSMerchant
import XCTest

class SelectTokenViewModelTests: XCTestCase {
    class TestSelectTokenDelegate: SelectTokenDelegate {
        var expectation: XCTestExpectation!
        var selectedToken: Token?

        func didSelectToken(_ token: Token) {
            self.selectedToken = token
            self.expectation.fulfill()
        }
    }

    var sessionManager: TestSessionManager!
    var tokenLoader: TestTokenLoader!
    var delegate: TestSelectTokenDelegate!
    var sut: SelectTokenViewModel!
    let selectedToken = StubGenerator.wallets().first!.balances.first!.token

    let userDefaultWrapper = UserDefaultsWrapper()

    override func setUp() {
        super.setUp()
        self.sessionManager = TestSessionManager()
        self.tokenLoader = TestTokenLoader()
        self.delegate = TestSelectTokenDelegate()
        self.sut = SelectTokenViewModel(tokenLoader: self.tokenLoader,
                                        sessionManager: self.sessionManager,
                                        delegate: self.delegate,
                                        selectedToken: self.selectedToken)
    }

    override func tearDown() {
        self.sessionManager = nil
        self.tokenLoader = nil
        self.delegate = nil
        super.tearDown()
    }

    func testLoadBalancesFailed() {
        var didFail = false
        let error: OMGError = .unexpected(message: "Failed to load balances")
        self.sut.onFailLoadTokens = {
            XCTAssertEqual($0.message, error.message)
            didFail = true
        }
        self.sut.loadBalances()
        self.tokenLoader.failure(withError: error)
        XCTAssert(didFail)
    }

    func testLoadBalancesFailedWhenNoToken() {
        var didFail = false
        self.sut.onFailLoadTokens = {
            XCTAssertEqual($0.message, "select_token.error.no_token".localized())
            didFail = true
        }
        self.sut.loadBalances()
        self.tokenLoader.success(withWallet: [],
                                 pagination: StubGenerator.pagination())
        XCTAssert(didFail)
    }

    func testCallReloadTableViewClosureOnSuccess() {
        var reloadTableViewClosureCalled = false
        self.sut.reloadTableViewClosure = {
            reloadTableViewClosureCalled = true
        }
        self.sut.loadBalances()
        let wallets = StubGenerator.wallets()
        let pagination = StubGenerator.pagination()
        self.tokenLoader.success(withWallet: wallets,
                                 pagination: pagination)
        XCTAssertTrue(reloadTableViewClosureCalled)
    }

    func testLoadingWhenRequesting() {
        var loadingStatus = false
        self.sut.onLoadStateChange = { loadingStatus = $0 }
        let wallets = StubGenerator.wallets()
        let pagination = StubGenerator.pagination()
        self.sut.loadBalances()
        XCTAssertTrue(loadingStatus)
        self.tokenLoader.success(withWallet: wallets,
                                 pagination: pagination)
        XCTAssertFalse(loadingStatus)
    }

    func testGetCellViewModel() {
        let wallets = StubGenerator.wallets()
        let pagination = StubGenerator.pagination()
        self.sut.loadBalances()
        self.tokenLoader.success(withWallet: wallets,
                                 pagination: pagination)

        XCTAssert(self.sut.numberOfRow() == wallets.count)

        let ip1 = IndexPath(row: 0, section: 0)
        let cvm1 = self.sut.tokenCellViewModel(at: ip1)
        XCTAssertEqual(cvm1.balance, wallets.first!.balances.first!)
    }

    func testSelectToken() {
        let wallets = StubGenerator.wallets()
        let pagination = StubGenerator.pagination()
        self.sut.loadBalances()
        self.tokenLoader.success(withWallet: wallets,
                                 pagination: pagination)
        let e = self.expectation(description: "Calls delegate when on token selection")
        self.delegate.expectation = e
        let ip = IndexPath(row: 1, section: 0)
        self.sut.selectToken(atIndexPath: ip)
        self.waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(self.delegate.selectedToken, self.sut.tokenCellViewModel(at: ip).balance.token)
    }
}
