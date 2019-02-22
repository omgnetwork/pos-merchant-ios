//
//  KeyboardViewModelTests.swift
//  POSMerchantTests
//
//  Created by Mederic Petit on 26/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import POSMerchant
import XCTest

class KeyboardViewModelTests: XCTestCase {
    var sut: KeyboardViewModel!
    var delegate: TestKeyboardViewModelDelegate!

    override func setUp() {
        super.setUp()
        self.delegate = TestKeyboardViewModelDelegate()
        self.sut = KeyboardViewModel(delegate: self.delegate)
    }

    override func tearDown() {
        super.tearDown()
        self.sut = nil
        self.delegate = nil
    }

    func testTapNumberCallsDelegate() {
        let e = self.expectation(description: "tap number calls delegate")
        self.delegate.expectation = e
        self.sut.tapNumber(1)
        self.waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(self.delegate.didTapNumberCalled, "1")
    }

    func testTapDecimalSeparatorCallsDelegate() {
        let e = self.expectation(description: "tap decimal separator calls delegate")
        self.delegate.expectation = e
        self.sut.tapDecimalSeparator()
        self.waitForExpectations(timeout: 1, handler: nil)
        let separator = Character(self.sut.decimalSeparator)
        XCTAssertEqual(self.delegate.didTapDecimalSeparatorCalled, separator)
    }

    func testTapDeleteCallsDelegate() {
        let e = self.expectation(description: "tap delete calls delegate")
        self.delegate.expectation = e
        self.sut.tapDelete()
        self.waitForExpectations(timeout: 1, handler: nil)
        XCTAssertTrue(self.delegate.didTapDeleteCalled)
    }

    class TestKeyboardViewModelDelegate: KeyboardEventDelegate {
        var didTapNumberCalled: String?
        var didTapDecimalSeparatorCalled: Character?
        var didTapDeleteCalled = false

        func didTapNumber(_ number: String, keyboardViewModel _: KeyboardViewModel) {
            self.didTapNumberCalled = number
            self.expectation.fulfill()
        }

        func didTapDecimalSeparator(_ character: Character) {
            self.didTapDecimalSeparatorCalled = character
            self.expectation.fulfill()
        }

        func didTapDelete() {
            self.didTapDeleteCalled = true
            self.expectation.fulfill()
        }

        var expectation: XCTestExpectation!
    }
}
