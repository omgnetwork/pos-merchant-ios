//
//  LoadingViewControllerTests.swift
//  POSMerchantTests
//
//  Created by Mederic Petit on 22/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import POSMerchant
import Toaster
import XCTest

class LoadingViewControllerTests: XCTestCase {
    var sut: LoadingViewController!
    var viewModel: TestLoadingViewModel!

    override func setUp() {
        super.setUp()
        self.viewModel = TestLoadingViewModel()
        self.sut = LoadingViewController.initWithViewModel(self.viewModel)
        _ = self.sut.view
    }

    override func tearDown() {
        super.tearDown()
        ToastCenter.default.cancelAll()
        self.viewModel = nil
        self.sut = nil
    }

    func testSetupsCorrectly() {
        XCTAssertEqual(self.sut.retryButton.titleLabel?.text, "x")
        XCTAssertTrue(self.sut.retryButton.isHidden)
    }

    func testFailedLoadinShowsError() {
        let error = POSMerchantError.unexpected
        self.viewModel.onFailedLoading?(error)
        XCTAssertEqual(ToastCenter.default.currentToast!.text, error.message)
    }

    func testLoadStateChangeTriggersLoadingAndRetryButtonVisibiliyChange() {
        self.viewModel.onLoadStateChange?(true)
        XCTAssertTrue(self.sut.loadingImageView.isAnimating)
        XCTAssertTrue(self.sut.retryButton.isHidden)
        self.viewModel.onLoadStateChange?(false)
        XCTAssertFalse(self.sut.loadingImageView.isAnimating)
        XCTAssertFalse(self.sut.retryButton.isHidden)
    }

    func testTapRetryButtonTriggersLoad() {
        self.sut.tapRetryButton(self.sut.retryButton)
        XCTAssertTrue(self.viewModel.isLoadCalled)
    }
}
