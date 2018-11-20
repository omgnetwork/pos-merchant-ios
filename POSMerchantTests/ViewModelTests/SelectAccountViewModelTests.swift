//
//  SelectAccountViewModelTests.swift
//  POSMerchantTests
//
//  Created by Mederic Petit on 25/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
@testable import POSMerchant
import XCTest

class SelectAccountViewModelTests: XCTestCase {
    var sessionManager: TestSessionManager!
    var accountLoader: TestAccountLoader!

    var currentAccountSut: SelectAccountViewModel!
    var exchangeAccountSut: SelectAccountViewModel!

    let userDefaultWrapper = UserDefaultsWrapper()

    override func setUp() {
        super.setUp()
        self.sessionManager = TestSessionManager()
        self.accountLoader = TestAccountLoader()
        self.currentAccountSut = SelectAccountViewModel(accountLoader: self.accountLoader,
                                                        sessionManager: self.sessionManager,
                                                        mode: .currentAccount,
                                                        delegate: nil)
        self.exchangeAccountSut = SelectAccountViewModel(accountLoader: self.accountLoader,
                                                         sessionManager: self.sessionManager,
                                                         mode: .exchangeAccount,
                                                         delegate: nil)
    }

    override func tearDown() {
        self.sessionManager = nil
        self.accountLoader = nil
        self.currentAccountSut = nil
        self.exchangeAccountSut = nil
        super.tearDown()
    }

    func testReloadAccounts() {
        self.currentAccountSut.reloadAccounts()
        XCTAssert(self.accountLoader.isListCalled)
        XCTAssertEqual(self.currentAccountSut.numberOfRow(), 0)
    }

    func testGetNextAccountsCalled() {
        self.currentAccountSut.getNextAccounts()
        XCTAssert(self.accountLoader.isListCalled)
    }

    func testLoadAccountsFailed() {
        var didFail = false
        let error: OMGError = .unexpected(message: "Failed to load accounts")
        self.currentAccountSut.onFailLoadAccounts = {
            XCTAssertEqual($0.message, error.message)
            didFail = true
        }
        self.currentAccountSut.getNextAccounts()
        self.accountLoader.failure(withError: error)
        XCTAssert(didFail)
    }

    func testLoadAccountsSuccess() {
        var appendNewResultClosureCalled = false
        var loadedIndexPath: [IndexPath] = []
        self.currentAccountSut.appendNewResultClosure = { indexPaths in
            appendNewResultClosureCalled = true
            loadedIndexPath = indexPaths
        }
        let accounts = StubGenerator.accounts()
        let pagination = StubGenerator.pagination()
        self.currentAccountSut.getNextAccounts()
        self.accountLoader.success(withAccount: accounts, pagination: pagination)
        XCTAssertTrue(appendNewResultClosureCalled)
        XCTAssertEqual(loadedIndexPath.count, accounts.count)
    }

    func testCallReloadTableViewClosureWhenViewModelsArrayIsEmpty() {
        var reloadTableViewClosureCalled = false
        self.currentAccountSut.reloadTableViewClosure = {
            reloadTableViewClosureCalled = true
        }
        self.currentAccountSut.reloadAccounts()
        XCTAssertTrue(reloadTableViewClosureCalled)
    }

    func testLoadingWhenRequesting() {
        var loadingStatus = false
        self.currentAccountSut.onLoadStateChange = { loadingStatus = $0 }
        let accounts = StubGenerator.accounts()
        let pagination = StubGenerator.pagination()
        self.currentAccountSut.getNextAccounts()
        XCTAssertTrue(loadingStatus)
        self.accountLoader.success(withAccount: accounts, pagination: pagination)
        XCTAssertFalse(loadingStatus)
    }

    func testGetCellViewModelForCurrentAccount() {
        let accounts = StubGenerator.accounts()
        let pagination = StubGenerator.pagination()
        self.sessionManager.selectedAccount = accounts[0]
        self.currentAccountSut.getNextAccounts()
        self.accountLoader.success(withAccount: accounts, pagination: pagination)

        XCTAssert(self.currentAccountSut.numberOfRow() == accounts.count)

        let ip1 = IndexPath(row: 0, section: 0)
        let cvm1 = self.currentAccountSut.accountCellViewModel(at: ip1)
        XCTAssertEqual(cvm1.account, accounts.first!)
        XCTAssertTrue(cvm1.isSelected)

        let ip2 = IndexPath(row: 1, section: 0)
        let cvm2 = self.currentAccountSut.accountCellViewModel(at: ip2)
        XCTAssertEqual(cvm2.account, accounts[1])
        XCTAssertFalse(cvm2.isSelected)
    }

    func testGetCellViewModelForExchangeAccount() {
        let accounts = StubGenerator.accounts()
        let pagination = StubGenerator.pagination()
        self.userDefaultWrapper.storeValue(value: accounts[0].id, forKey: .exchangeAccountId)
        self.exchangeAccountSut.getNextAccounts()
        self.accountLoader.success(withAccount: accounts, pagination: pagination)

        XCTAssert(self.exchangeAccountSut.numberOfRow() == accounts.count)

        let ip1 = IndexPath(row: 0, section: 0)
        let cvm1 = self.exchangeAccountSut.accountCellViewModel(at: ip1)
        XCTAssertEqual(cvm1.account, accounts.first!)
        XCTAssertTrue(cvm1.isSelected)

        let ip2 = IndexPath(row: 1, section: 0)
        let cvm2 = self.exchangeAccountSut.accountCellViewModel(at: ip2)
        XCTAssertEqual(cvm2.account, accounts[1])
        XCTAssertFalse(cvm2.isSelected)
        self.userDefaultWrapper.clearValue(forKey: .exchangeAccountId)
    }

    func testCellViewModel() {
        let account = StubGenerator.accounts()[0]
        let cellViewModel = AccountCellViewModel(account: account, isSelected: true)
        XCTAssertEqual(cellViewModel.name, "Headquarter")
        XCTAssertEqual(cellViewModel.imageURL,
                       URL(string: "http://192.168.82.18:4000/public/uploads/dev/account/avatars/acc_01cs94yc3x4gggm6pwq2fhh1kv/small.png?v=63706198634"))
        XCTAssertEqual(cellViewModel.shortName, "H")
        XCTAssertTrue(cellViewModel.isSelected)

        let cellViewModelNotSelected = AccountCellViewModel(account: account, isSelected: false)
        XCTAssertFalse(cellViewModelNotSelected.isSelected)
    }

    func testSelectAccountForCurrentAccount() {
        let accounts = StubGenerator.accounts()
        let pagination = StubGenerator.pagination()
        self.sessionManager.selectedAccount = accounts[0]
        let e = self.expectation(description: "Calls delegate when on account selection")
        let delegate = TestSelectAccountDelegate(expectation: e)
        let sut = SelectAccountViewModel(accountLoader: self.accountLoader,
                                         sessionManager: self.sessionManager,
                                         mode: .currentAccount,
                                         delegate: delegate)
        sut.getNextAccounts()
        self.accountLoader.success(withAccount: accounts, pagination: pagination)

        let ip1 = IndexPath(row: 0, section: 0)
        let ip2 = IndexPath(row: 1, section: 0)

        let cvm1 = sut.accountCellViewModel(at: ip1)
        let cvm2 = sut.accountCellViewModel(at: ip2)
        XCTAssertTrue(cvm1.isSelected)
        XCTAssertFalse(cvm2.isSelected)

        sut.selectAccount(atIndexPath: ip2)

        XCTAssertTrue(self.sessionManager.selectCurrentAccountCalled)
        XCTAssertFalse(cvm1.isSelected)
        XCTAssertTrue(cvm2.isSelected)
        self.waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(delegate.account, cvm2.account)
        XCTAssertEqual(delegate.mode!, .currentAccount)
    }

    func testSelectAccountForExchangeAccount() {
        let accounts = StubGenerator.accounts()
        let pagination = StubGenerator.pagination()
        self.userDefaultWrapper.storeValue(value: accounts[0].id, forKey: .exchangeAccountId)
        self.userDefaultWrapper.storeValue(value: accounts[0].name, forKey: .exchangeAccountName)
        let e = self.expectation(description: "Calls delegate when on account selection")
        let delegate = TestSelectAccountDelegate(expectation: e)
        let sut = SelectAccountViewModel(accountLoader: self.accountLoader,
                                         sessionManager: self.sessionManager,
                                         mode: .exchangeAccount,
                                         delegate: delegate)
        sut.getNextAccounts()
        self.accountLoader.success(withAccount: accounts, pagination: pagination)

        let ip1 = IndexPath(row: 0, section: 0)
        let ip2 = IndexPath(row: 1, section: 0)

        let cvm1 = sut.accountCellViewModel(at: ip1)
        let cvm2 = sut.accountCellViewModel(at: ip2)
        XCTAssertTrue(cvm1.isSelected)
        XCTAssertFalse(cvm2.isSelected)

        sut.selectAccount(atIndexPath: ip2)

        XCTAssertEqual(cvm2.account.id, self.userDefaultWrapper.getValue(forKey: .exchangeAccountId))
        XCTAssertEqual(cvm2.account.name, self.userDefaultWrapper.getValue(forKey: .exchangeAccountName))

        XCTAssertFalse(cvm1.isSelected)
        XCTAssertTrue(cvm2.isSelected)
        self.waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(delegate.account, cvm2.account)
        XCTAssertEqual(delegate.mode!, .exchangeAccount)

        self.userDefaultWrapper.clearValue(forKey: .exchangeAccountId)
        self.userDefaultWrapper.clearValue(forKey: .exchangeAccountName)
    }

    class TestSelectAccountDelegate: SelectAccountViewModelDelegate {
        var account: Account?
        var mode: SelectAccountMode?
        let expectation: XCTestExpectation

        init(expectation: XCTestExpectation) {
            self.expectation = expectation
        }

        func didSelectAccount(account: Account, forMode mode: SelectAccountMode) {
            self.account = account
            self.mode = mode
            self.expectation.fulfill()
        }
    }
}
