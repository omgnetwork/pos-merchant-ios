//
//  TransactionsViewControllerTests.swift
//  POSMerchantTests
//
//  Created by Mederic Petit on 30/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import POSMerchant
import SBToaster
import XCTest

class TransactionsViewControllerTests: XCTestCase {
    var sut: TransactionsViewController!
    var viewModel: TestTransactionsViewModel!

    override func setUp() {
        super.setUp()
        self.viewModel = TestTransactionsViewModel()
        self.sut = TransactionsViewController.initWithViewModel(self.viewModel)
        _ = UINavigationController(rootViewController: self.sut)
        _ = self.sut.view
    }

    override func tearDown() {
        super.tearDown()
        ToastCenter.default.cancelAll()
        self.sut = nil
    }

    func testSetupsCorrectly() {
        XCTAssertEqual(self.sut.title, "x")
        XCTAssertEqual(self.sut.tableView.estimatedRowHeight, 62)
        XCTAssertEqual(self.sut.tableView.rowHeight, 62)
        XCTAssertEqual(self.sut.tableView.refreshControl, self.sut.refreshControl)
        self.viewModel.isReloadTransactionCalled = true
    }

    func testReloadTableViewClosureEndRefres() {
        self.sut.refreshControl!.beginRefreshing()
        XCTAssertTrue(self.sut.refreshControl!.isRefreshing)
        self.viewModel.reloadTableViewClosure?()
        XCTAssertFalse(self.sut.refreshControl!.isRefreshing)
    }

    func testFailedLoadingShowsErrorAndEndRefresh() {
        self.sut.refreshControl!.beginRefreshing()
        XCTAssertTrue(self.sut.refreshControl!.isRefreshing)
        let error = POSMerchantError.unexpected
        self.viewModel.onFailLoadTransactions?(error)
        XCTAssertEqual(ToastCenter.default.currentToast!.text, error.message)
        XCTAssertFalse(self.sut.refreshControl!.isRefreshing)
    }

    func testAppendNewResultClosureInsertsDataInTable() {
        self.viewModel.rowCount = 1
        let indexPath = IndexPath(row: 0, section: 0)
        self.viewModel.appendNewResultClosure?([indexPath])
        let cell = self.sut.tableView(self.sut.tableView, cellForRowAt: indexPath)
        XCTAssertNotNil(cell)
    }

    func testRefreshControllerTriggersReloadTransactions() {
        self.sut.refreshControl!.sendActions(for: .valueChanged)
        XCTAssertTrue(self.viewModel.isReloadTransactionCalled)
    }

    func testNumberOfRowInSection() {
        self.viewModel.rowCount = 10
        XCTAssertEqual(self.sut.tableView(self.sut.tableView, numberOfRowsInSection: 0), 10)
    }

    func testCellForRow() {
        let cell = self.sut.tableView(self.sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as! TransactionTableViewCell
        XCTAssertEqual(cell.transactionCellViewModel, self.viewModel.cellVM)
    }

    func testWillDisplayCellTriggersLoadNextCorrectly() {
        let indexPath = IndexPath(row: 0, section: 0)
        self.sut.tableView(self.sut.tableView, willDisplay: TransactionTableViewCell(style: .default, reuseIdentifier: nil), forRowAt: indexPath)
        XCTAssertEqual(self.viewModel.isShouldLoadNextCalledWithIndexPath!, indexPath)
    }
}
