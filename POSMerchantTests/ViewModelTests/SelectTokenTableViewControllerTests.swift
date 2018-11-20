//
//  SelectTokenTableViewControllerTests.swift
//  POSMerchantTests
//
//  Created by Mederic Petit on 26/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import POSMerchant
import Toaster
import XCTest

class SelectTokenTableViewControllerTests: XCTestCase {
    var sut: SelectTokenTableViewController!
    var viewModel: TestSelectTokenViewModel!

    override func setUp() {
        super.setUp()
        self.viewModel = TestSelectTokenViewModel()
        self.sut = SelectTokenTableViewController.initWithViewModel(self.viewModel)
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
        self.viewModel.loadBalancesCalled = true
    }

    func testReloadTableViewClosureEndRefresh() {
        self.sut.refreshControl!.beginRefreshing()
        XCTAssertTrue(self.sut.refreshControl!.isRefreshing)
        self.viewModel.reloadTableViewClosure?()
        XCTAssertFalse(self.sut.refreshControl!.isRefreshing)
    }

    func testFailedLoadingShowsErrorAndEndRefresh() {
        self.sut.refreshControl!.beginRefreshing()
        XCTAssertTrue(self.sut.refreshControl!.isRefreshing)
        let error = POSMerchantError.unexpected
        self.viewModel.onFailLoadTokens?(error)
        XCTAssertEqual(ToastCenter.default.currentToast!.text, error.message)
        XCTAssertFalse(self.sut.refreshControl!.isRefreshing)
    }

    func testRefreshControllerTriggersReloadTransactions() {
        self.sut.refreshControl!.sendActions(for: .valueChanged)
        XCTAssertTrue(self.viewModel.loadBalancesCalled)
    }

    func testNumberOfRowInSection() {
        self.viewModel.rowCount = 10
        XCTAssertEqual(self.sut.tableView(self.sut.tableView, numberOfRowsInSection: 0), 10)
    }

    func testCellForRow() {
        self.viewModel.balanceCellViewModel =
            BalanceCellViewModel(balance: StubGenerator.wallets().first!.balances.first!, isSelected: true)
        let cell = self.sut.tableView(self.sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as! BalanceTableViewCell
        XCTAssertEqual(cell.balanceCellViewModel, self.viewModel.balanceCellViewModel)
    }

    func testSelectRow() {
        let ip = IndexPath(row: 0, section: 0)
        self.sut.tableView(self.sut.tableView, didSelectRowAt: ip)
        XCTAssertEqual(self.viewModel.selectTokenAtIndexPath, ip)
    }
}
