//
//  KeyboardViewModel.swift
//  POSMerchant
//
//  Created by Mederic Petit on 27/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

protocol KeyboardEventDelegate: class {
    func didTapCharacter(_ character: String)
    func didTapDelete()
}

class KeyboardViewModel: BaseViewModel, KeyboardViewModelProtocol {
    weak var delegate: KeyboardEventDelegate?
    let decimalSeparator: String = NSLocale.current.decimalSeparator ?? "."

    required init(delegate: KeyboardEventDelegate? = nil) {
        self.delegate = delegate
    }

    func tapNumber(_ number: Int) {
        self.delegate?.didTapCharacter(String(number))
    }

    func tapDecimalSeparator() {
        self.delegate?.didTapCharacter(self.decimalSeparator)
    }

    func tapDelete() {
        self.delegate?.didTapDelete()
    }
}
