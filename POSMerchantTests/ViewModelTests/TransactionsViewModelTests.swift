//
//  TransactionsViewModelTests.swift
//  POSMerchantTests
//
//  Created by Mederic Petit on 30/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
@testable import POSMerchant
import XCTest

class TransactionsViewModelTests: XCTestCase {
    var sessionManager: TestSessionManager!
    var transactionLoader: TestTransactionLoader!
    var sut: TransactionsViewModel!

    override func setUp() {
        super.setUp()
        self.sessionManager = TestSessionManager()
        self.transactionLoader = TestTransactionLoader()
        self.sut = TransactionsViewModel(transactionLoader: self.transactionLoader, sessionManager: self.sessionManager)
    }

    override func tearDown() {
        self.sessionManager = nil
        self.transactionLoader = nil
        self.sut = nil
        super.tearDown()
    }

    func testReloadTransactions() {
        self.sut.reloadTransactions()
        XCTAssert(self.transactionLoader.isListCalled)
    }

    func testGetNextTransactionsCalled() {
        self.sut.getNextTransactions()
        XCTAssert(self.transactionLoader.isListCalled)
    }

    func testLoadTransactionsFailed() {
        var didFail = false
        let error: OMGError = .unexpected(message: "Failed to load transactions")
        self.sut.onFailLoadTransactions = {
            XCTAssertEqual($0.message, error.message)
            didFail = true
        }
        self.transactionLoader.transactions = StubGenerator.transactions()
        self.transactionLoader.pagination = StubGenerator.pagination()
        self.sut.getNextTransactions()
        self.transactionLoader.loadTransactionFailed(withError: error)
        XCTAssert(didFail)
    }

    func testLoadTransactionsSuccess() {
        self.sessionManager.selectedAccount = StubGenerator.accounts().first!
        var appendNewResultClosureCalled = false
        var loadedIndexPath: [IndexPath] = []
        self.sut.appendNewResultClosure = { indexPaths in
            appendNewResultClosureCalled = true
            loadedIndexPath = indexPaths
        }
        self.goToLoadTransactionsFinished()
        XCTAssertTrue(appendNewResultClosureCalled)
        XCTAssertEqual(loadedIndexPath.count, self.transactionLoader.transactions!.count)
    }

    func testCallReloadTableViewClosureWhenViewModelsArrayIsEmpty() {
        var reloadTableViewClosureCalled = false
        self.sut.reloadTableViewClosure = {
            reloadTableViewClosureCalled = true
        }
        self.sut.reloadTransactions()
        XCTAssertTrue(reloadTableViewClosureCalled)
    }

    func testLoadingWhenRequesting() {
        var loadingStatus = false
        self.sut.onLoadStateChange = { loadingStatus = $0 }
        self.transactionLoader.transactions = StubGenerator.transactions()
        self.transactionLoader.pagination = StubGenerator.pagination()
        self.sut.getNextTransactions()
        XCTAssertTrue(loadingStatus)
        self.transactionLoader.loadTransactionSuccess()
        XCTAssertFalse(loadingStatus)
    }

    func testGetCellViewModel() {
        self.sessionManager.selectedAccount = StubGenerator.accounts().first!
        self.goToLoadTransactionsFinished()
        XCTAssert(self.sut.numberOfRow() == self.transactionLoader.transactions!.count)
        let indexPath = IndexPath(row: 0, section: 0)
        let cellViewModel = self.sut.transactionCellViewModel(at: indexPath)
        XCTAssertEqual(cellViewModel.name, "Starbucks - CDC > email@example.com")
    }

    func testCellViewModel() {
        let transactionCredit = StubGenerator.transactions()[0]
        let cellViewModelDebit = TransactionCellViewModel(transaction: transactionCredit, currentAccount: transactionCredit.from.account!)
        XCTAssertEqual(cellViewModelDebit.name, "email@example.com")
        XCTAssertEqual(cellViewModelDebit.amount, "- 10 TK1")
        XCTAssertEqual(cellViewModelDebit.color, Color.redError.uiColor())
        XCTAssertEqual(cellViewModelDebit.statusText, "transactions.label.status.success".localized())
        let transactionDebit = StubGenerator.transactions()[1]
        let cellViewModelCredit = TransactionCellViewModel(transaction: transactionDebit, currentAccount: transactionDebit.to.account!)
        XCTAssertEqual(cellViewModelCredit.name, "email@example.com")
        XCTAssertEqual(cellViewModelCredit.amount, "+ 10 TK1")
        XCTAssertEqual(cellViewModelCredit.color, Color.transactionCreditGreen.uiColor())
        XCTAssertEqual(cellViewModelCredit.statusText, "transactions.label.status.success".localized())

        let transactionOtherAccount = StubGenerator.transactions()[0]
        let account = StubGenerator.accounts().first!
        let cellViewModelOtherAccount = TransactionCellViewModel(transaction: transactionOtherAccount, currentAccount: account)
        XCTAssertEqual(cellViewModelOtherAccount.name, "Starbucks - CDC > email@example.com")
        XCTAssertEqual(cellViewModelOtherAccount.amount, " 10 TK1")
        XCTAssertEqual(cellViewModelOtherAccount.color, Color.greyUnderline.uiColor())
        XCTAssertEqual(cellViewModelOtherAccount.statusText, "transactions.label.status.success".localized())
    }
}

extension TransactionsViewModelTests {
    private func goToLoadTransactionsFinished() {
        self.transactionLoader.transactions = StubGenerator.transactions()
        self.transactionLoader.pagination = StubGenerator.pagination()
        self.sut.getNextTransactions()
        self.transactionLoader.loadTransactionSuccess()
    }
}
