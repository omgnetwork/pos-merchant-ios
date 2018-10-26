//
//  TestKeyboardViewModel.swift
//  POSMerchantTests
//
//  Created by Mederic Petit on 26/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import POSMerchant
import UIKit

class TestKeyboardViewModel {
    var tapNumberCalled: Int?
    var tapDecimalSeparatorCalled = false
    var tapDeleteCalled = false
}

extension TestKeyboardViewModel: KeyboardViewModelProtocol {
    func tapNumber(_ number: Int) {
        self.tapNumberCalled = number
    }

    func tapDecimalSeparator() {
        self.tapDecimalSeparatorCalled = true
    }

    func tapDelete() {
        self.tapDeleteCalled = true
    }
}
