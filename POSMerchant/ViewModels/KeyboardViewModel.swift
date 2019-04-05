//
//  KeyboardViewModel.swift
//  POSMerchant
//
//  Created by Mederic Petit on 27/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

protocol KeyboardEventDelegate: AnyObject {
    func didTapNumber(_ number: String, keyboardViewModel: KeyboardViewModel)
    func didTapDecimalSeparator(_ character: Character)
    func didTapDelete()
}

class KeyboardViewModel: BaseViewModel, KeyboardViewModelProtocol {
    weak var delegate: KeyboardEventDelegate?
    let decimalSeparator: String = NSLocale.current.decimalSeparator ?? "."

    required init(delegate: KeyboardEventDelegate? = nil) {
        self.delegate = delegate
    }

    func tapNumber(_ number: Int) {
        self.delegate?.didTapNumber(String(number), keyboardViewModel: self)
    }

    func tapDecimalSeparator() {
        self.delegate?.didTapDecimalSeparator(Character(self.decimalSeparator))
    }

    func tapDelete() {
        self.delegate?.didTapDelete()
    }
}
