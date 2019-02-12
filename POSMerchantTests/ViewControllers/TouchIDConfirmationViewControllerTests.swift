//
//  TouchIDConfirmationViewControllerTests.swift
//  POSMerchantTests
//
//  Created by Mederic Petit on 30/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import POSMerchant
import SBToaster
import XCTest

class TouchIDConfirmationViewControllerTests: XCTestCase {
    var sut: TouchIDConfirmationViewController!
    var viewModel: TestTouchIDConfirmationViewModel!

    override func setUp() {
        super.setUp()
        self.viewModel = TestTouchIDConfirmationViewModel()
        self.sut = TouchIDConfirmationViewController.initWithViewModel(self.viewModel)
        _ = UINavigationController(rootViewController: self.sut)
        _ = self.sut.view
    }

    override func tearDown() {
        super.tearDown()
        ToastCenter.default.cancelAll()
        self.viewModel = nil
        self.sut = nil
    }

    private func mountOnWindow() {
        let w = UIWindow()
        w.addSubview(self.sut.view)
        w.makeKeyAndVisible()
    }

    func testSetupsCorrectly() {
        XCTAssertEqual(self.sut.emailLabel.text, "x")
        XCTAssertEqual(self.sut.passwordTextField.placeholder, "x")
        XCTAssertEqual(self.sut.hintLabel.text, "x")
        XCTAssertEqual(self.sut.enableButton.titleLabel?.text, "x")
    }

    func testInvalidPasswordShowsError() {
        self.viewModel.updatePasswordValidation?("123")
        XCTAssertEqual(self.sut.passwordTextField.errorMessage, "123")
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

    func testFailedEnableShowsError() {
        let error = POSMerchantError.unexpected
        self.viewModel.onFailedEnable?(error)
        XCTAssertEqual(ToastCenter.default.currentToast!.text, error.message)
    }

    func testOnSuccessEnablePopsViewController() {
        let dummyVC = UIViewController(nibName: nil, bundle: nil)
        let navVC = UINavigationController(rootViewController: dummyVC)
        navVC.pushViewController(self.sut, animated: false)
        XCTAssertEqual(navVC.viewControllers.count, 2)
        let e = self.expectation(description: "Pops view controller")
        self.viewModel.onSuccessEnable?()
        dispatchMain {
            e.fulfill()
        }
        self.waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(navVC.viewControllers.count, 1)
        XCTAssertEqual(navVC.viewControllers[0], dummyVC)
    }

    func testPasswordTextFieldChangeUpdatesViewModelPasswordAttribute() {
        let range = NSRange(location: 0, length: 0)
        _ = self.sut.textField(self.sut.passwordTextField, shouldChangeCharactersIn: range, replacementString: "123")
        XCTAssertEqual(self.viewModel.password, "123")
    }

    func testReturningPasswordTFResignFirstResponderAndTriggersEnable() {
        self.mountOnWindow()
        self.sut.passwordTextField.becomeFirstResponder()
        XCTAssertTrue(self.sut.passwordTextField.isFirstResponder)
        _ = self.sut.textFieldShouldReturn(self.sut.passwordTextField)
        let e = self.expectation(description: "Returning password tf triggers enable")
        dispatchMain { e.fulfill() }
        self.waitForExpectations(timeout: 1, handler: nil)
        XCTAssertFalse(self.sut.passwordTextField.isFirstResponder)
        XCTAssertTrue(self.viewModel.isEnableCalled)
    }

    func testClearPWTFClearsViewModelPW() {
        self.viewModel.password = "123"
        _ = self.sut.textFieldShouldClear(self.sut.passwordTextField)
        XCTAssertEqual(self.viewModel.password, "")
    }

    func testTapEnableButtonTriggersEnableAndResignFirstResponder() {
        self.mountOnWindow()
        self.sut.passwordTextField.becomeFirstResponder()
        XCTAssertTrue(self.sut.passwordTextField.isFirstResponder)
        self.sut.tapEnableButton(self.sut.enableButton)
        let e = self.expectation(description: "Tap on enable button resigns first responder and trigger enable")
        dispatchMain { e.fulfill() }
        self.waitForExpectations(timeout: 1, handler: nil)
        XCTAssertFalse(self.sut.passwordTextField.isFirstResponder)
        XCTAssertTrue(self.viewModel.isEnableCalled)
    }
}
