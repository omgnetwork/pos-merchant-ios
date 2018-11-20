//
//  KeyboardViewControllerTests.swift
//  POSMerchantTests
//
//  Created by Mederic Petit on 26/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import POSMerchant
import XCTest

class KeyboardViewControllerTests: XCTestCase {
    var sut: KeyboardViewController!
    var viewModel: TestKeyboardViewModel!

    override func setUp() {
        super.setUp()
        self.viewModel = TestKeyboardViewModel()
        self.sut = KeyboardViewController.initWithViewModel(self.viewModel)
    }

    override func tearDown() {
        super.tearDown()
        self.viewModel = nil
        self.sut = nil
    }

    func testTapNumberButton() {
        let button = UIButton()
        button.tag = 1
        self.sut.didTapNumber(button)
        XCTAssertEqual(self.viewModel.tapNumberCalled, 1)
    }

    func testTapDecimalSeparator() {
        self.sut.didTapDecimalSeparatorButton(UIButton())
        XCTAssertTrue(self.viewModel.tapDecimalSeparatorCalled)
    }

    func testTapDeleteButton() {
        self.sut.didTapDeleteButton(UIButton())
        XCTAssertTrue(self.viewModel.tapDeleteCalled)
    }
}
