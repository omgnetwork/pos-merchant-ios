//
//  SelectAccountViewContollerTests.swift
//  POSMerchantTests
//
//  Created by Mederic Petit on 25/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import POSMerchant
import Toaster
import XCTest

class SelectAccountViewContollerTests: XCTestCase {
    var sut: SelectAccountTableViewController!
    var viewModel: TestSelectAccountViewModel!

    override func setUp() {
        super.setUp()
        self.viewModel = TestSelectAccountViewModel()
        self.sut = SelectAccountTableViewController.initWithViewModel(self.viewModel)
        _ = UINavigationController(rootViewController: self.sut)
        _ = self.sut.view
    }

    override func tearDown() {
        super.tearDown()
        ToastCenter.default.cancelAll()
        self.sut = nil
        self.viewModel = nil
    }

    func testSetupsCorrectly() {
        XCTAssertEqual(self.sut.title, "x")
        XCTAssertEqual(self.sut.tableView.estimatedRowHeight, 64)
        XCTAssertEqual(self.sut.tableView.rowHeight, 64)
        XCTAssertEqual(self.sut.tableView.refreshControl, self.sut.refreshControl)
        self.viewModel.reloadAccountCalled = true
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
        self.viewModel.onFailLoadAccounts?(error)
        XCTAssertEqual(ToastCenter.default.currentToast!.text, error.message)
        XCTAssertFalse(self.sut.refreshControl!.isRefreshing)
    }

    func testAppendNewResultClosureInsertsDataInTable() {
        self.viewModel.rowCount = 1
        self.viewModel.accountCellViewModel = AccountCellViewModel(account: StubGenerator.accounts().first!,
                                                                   isSelected: true)
        let indexPath = IndexPath(row: 0, section: 0)
        self.viewModel.appendNewResultClosure?([indexPath])
        let cell = self.sut.tableView(self.sut.tableView, cellForRowAt: indexPath)
        XCTAssertNotNil(cell)
    }

    func testRefreshControllerTriggersReloadTransactions() {
        self.sut.refreshControl!.sendActions(for: .valueChanged)
        XCTAssertTrue(self.viewModel.reloadAccountCalled)
    }

    func testNumberOfRowInSection() {
        self.viewModel.rowCount = 10
        XCTAssertEqual(self.sut.tableView(self.sut.tableView, numberOfRowsInSection: 0), 10)
    }

    func testCellForRow() {
        self.viewModel.accountCellViewModel = AccountCellViewModel(account: StubGenerator.accounts().first!,
                                                                   isSelected: true)
        let cell = self.sut.tableView(self.sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as! AccountTableViewCell
        XCTAssertEqual(cell.accountCellViewModel, self.viewModel.accountCellViewModel)
    }

    func testWillDisplayCellTriggersLoadNextCorrectly() {
        let indexPath = IndexPath(row: 0, section: 0)
        self.sut.tableView(self.sut.tableView, willDisplay: TransactionTableViewCell(style: .default, reuseIdentifier: nil), forRowAt: indexPath)
        XCTAssertEqual(self.viewModel.shouldLoadNextAtIndexPathCalled!, indexPath)
    }

    func testSelectRow() {
        let ip = IndexPath(row: 0, section: 0)
        self.sut.tableView(self.sut.tableView, didSelectRowAt: ip)
        XCTAssertEqual(self.viewModel.selectAccountAtIndexPathCalled, ip)
    }
}
