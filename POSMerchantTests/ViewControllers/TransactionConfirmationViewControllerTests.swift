//
//  TransactionConfirmationViewControllerTests.swift
//  POSMerchantTests
//
//  Created by Mederic Petit on 29/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
@testable import POSMerchant
import SBToaster
import XCTest

class TransactionConfirmationViewControllerTests: XCTestCase {
    var sut: TransactionConfirmationViewController!
    var viewModel: TestTransactionConfirmationViewModel!

    override func setUp() {
        super.setUp()
        self.viewModel = TestTransactionConfirmationViewModel()
        self.sut = TransactionConfirmationViewController.initWithViewModel(self.viewModel)
        _ = self.sut.view
    }

    override func tearDown() {
        super.tearDown()
        ToastCenter.default.cancelAll()
        self.sut = nil
        self.viewModel = nil
    }

    func mountOnWindow() {
        let w = UIWindow()
        w.addSubview(self.sut.view)
        w.makeKeyAndVisible()
    }

    func testSetupsCorrectly() {
        XCTAssertEqual(self.sut.titleLabel.text, "x")
        XCTAssertEqual(self.sut.tokenLabel.text, "x")
        XCTAssertEqual(self.sut.directionLabel.text, "x")
        XCTAssertEqual(self.sut.usernameLabel.text, "x")
        XCTAssertEqual(self.sut.userIdLabel.text, "x")
        XCTAssertEqual(self.sut.confirmButton.titleLabel?.text, "x")
        XCTAssertEqual(self.sut.cancelButton.titleLabel?.text, "x")
        XCTAssertFalse(self.sut.confirmButton.isEnabled)
        XCTAssertEqual(self.sut.confirmButton.alpha, 0.5)
        XCTAssertEqual(self.sut.userDisplayAmount.text, "x")
        self.viewModel.loadTransactionRequestCalled = true
    }

    func testLoadStateChangeTriggersLoading() {
        let e = self.expectation(description: "loading state change triggers loading view to show/hide")
        self.viewModel.onLoadStateChange?(true)
        XCTAssertEqual(self.sut.loading!.alpha, 1.0)
        self.viewModel.onLoadStateChange?(false)
        dispatchMain(afterMilliseconds: 10) {
            e.fulfill()
        }
        self.waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(self.sut.loading!.alpha, 0)
    }

    func testSuccessGetTransactionRequest() {
        self.viewModel.username = "y"
        self.viewModel.userId = "y"
        self.viewModel.userExpectedAmountDisplay = "y"
        self.viewModel.isReady = true
        self.viewModel.onSuccessGetTransactionRequest?()
        XCTAssertEqual(self.sut.usernameLabel.text, "y")
        XCTAssertEqual(self.sut.userIdLabel.text, "y")
        XCTAssertEqual(self.sut.userDisplayAmount.text, "y")
        XCTAssertTrue(self.sut.confirmButton.isEnabled)
        XCTAssertEqual(self.sut.confirmButton.alpha, 1)
    }

    func testFailGetTransactionRequestShowsErrorAndPopViewController() {
        let error = POSMerchantError.unexpected
        let dummyVC = UIViewController()
        let navVC = UINavigationController()
        let w = UIWindow()
        w.addSubview(navVC.view)
        w.makeKeyAndVisible()
        navVC.viewControllers = [dummyVC, self.sut]
        let e = self.expectation(description: "Pops view controller")
        self.viewModel.onFailGetTransactionRequest?(error)
        dispatchMain {
            e.fulfill()
        }
        self.waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(ToastCenter.default.currentToast!.text, error.message)
        XCTAssertEqual(navVC.viewControllers.count, 1)
    }

    func testOnPendingConsumptionShowsConfirmationView() {
        self.mountOnWindow()
        XCTAssertNil(self.sut.presentedViewController)
        self.viewModel.onPendingConsumptionConfirmation?()
        XCTAssertNotNil(self.sut.presentedViewController)
    }

    func testOnCompleteConsumption() {
        let token = StubGenerator.wallets().first!.balances.first!.token
        let builder = TransactionBuilder(type: .receive,
                                         amount: "1",
                                         token: token,
                                         decodedString: "123|456")!
        let navVC = UINavigationController(rootViewController: self.sut)
        let w = UIWindow()
        w.addSubview(navVC.view)
        w.makeKeyAndVisible()
        let e = self.expectation(description: "Push view controller")
        self.viewModel.onCompletedConsumption?(builder)
        dispatchMain {
            e.fulfill()
        }
        self.waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(navVC.viewControllers.count, 2)
    }

    func testTapConfirmButtonCallsPerformTransaction() {
        self.sut.tapConfirmButton(self.sut.confirmButton)
        XCTAssertTrue(self.viewModel.performTransactionCalled)
    }

    func testTapCancelButtonPopsController() {
        let dummyVC = UIViewController()
        let navVC = UINavigationController()
        let w = UIWindow()
        w.addSubview(navVC.view)
        w.makeKeyAndVisible()
        navVC.viewControllers = [dummyVC, self.sut]
        let e = self.expectation(description: "Pops view controller")
        self.sut.tapCancelButton(UIButton())
        dispatchMain {
            e.fulfill()
        }
        self.waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(navVC.viewControllers.count, 1)
        XCTAssertTrue(self.viewModel.stopListeningCalled)
    }
}
