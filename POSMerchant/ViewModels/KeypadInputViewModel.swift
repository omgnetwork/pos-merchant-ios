//
//  KeypadInputViewModel.swift
//  POSMerchant
//
//  Created by Mederic Petit on 27/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
import UIKit

class KeypadInputViewModel: BaseViewModel, KeypadInputViewModelProtocol {
    // Override in subclass
    var title: String {
        fatalError("Subclass should override this variable")
    }

    var buttonTitle: String {
        fatalError("Subclass should override this variable")
    }

    func qrReaderStrings() -> (String, String) {
        fatalError("Subclass should override this method")
    }

    func didDecode(_: String) {
        fatalError("Subclass should override this method")
    }

    var displayAmount: String {
        didSet {
            self.onAmountUpdate?(self.displayAmount)
            self.checkIfReady()
        }
    }

    var tokenString: String
    var onAmountUpdate: ObjectClosure<String>?
    var onTokenUpdate: ObjectClosure<String>?
    var onFailGetDefaultToken: FailureClosure?
    var onReadyStateChange: ObjectClosure<Bool>?
    var onAmountValidationChange: ObjectClosure<Bool>?
    var shouldProcessTransaction: ObjectClosure<TransactionBuilder>?
    var onInvalidQRCodeFormat: FailureClosure?
    var selectedToken: Token? {
        didSet {
            self.tokenString = self.selectedToken?.name ?? "-"
            self.onTokenUpdate?(self.tokenString)
            self.checkIfReady()
        }
    }

    var isReady: Bool = false {
        didSet {
            self.onReadyStateChange?(self.isReady)
        }
    }

    var isAmountValid: Bool = false {
        didSet {
            self.onAmountValidationChange?(self.isAmountValid)
        }
    }

    let tokenLoader: TokenLoaderProtocol
    let sessionManager: SessionManagerProtocol

    init(tokenLoader: TokenLoaderProtocol = TokenLoader(),
         sessionManager: SessionManagerProtocol = SessionManager.shared) {
        self.tokenLoader = tokenLoader
        self.sessionManager = sessionManager
        self.displayAmount = "0"
        self.tokenString = "-"
        super.init()
        self.loadDefaultToken()
    }

    func loadDefaultToken() {
        let primaryFilter = Wallet.filter(field: .identifier, comparator: .equal, value: "primary")
        let paginationParams = PaginatedListParams<Wallet>(page: 1,
                                                           perPage: 1,
                                                           filters: FilterParams(matchAll: [primaryFilter]),
                                                           sortBy: .address,
                                                           sortDirection: .ascending)
        let params = WalletListForAccountParams(paginatedListParams: paginationParams,
                                                accountId: self.sessionManager.selectedAccount?.id ?? "",
                                                owned: true)
        self.tokenLoader.listForAccount(withParams: params) { result in
            switch result {
            case let .success(data: paginatedWallets):
                guard let token = paginatedWallets.data.first?.balances.first?.token else {
                    self.onFailGetDefaultToken?(POSMerchantError.message(message: "keypad_input.error.no_token".localized()))
                    return
                }
                self.selectedToken = token
            case let .failure(error):
                self.onFailGetDefaultToken?(.omiseGO(error: error))
            }
        }
    }

    func didTapNumber(_ number: String, keyboardViewModel: KeyboardViewModel) {
        let newNumber = self.displayAmount.appending(number)
        if self.displayAmount == "0" {
            if number == "0" { return }
            self.displayAmount = number
        } else if let token = self.selectedToken,
            let index = newNumber.firstIndex(where: { String($0) == keyboardViewModel.decimalSeparator }) {
            let fractionalDigits = newNumber.distance(from: newNumber.index(after: index), to: newNumber.endIndex)
            let maxAvailableDecimal = Int(log10(Double(token.subUnitToUnit)))
            guard fractionalDigits <= maxAvailableDecimal else { return }
            self.displayAmount.append(number)
        } else {
            self.displayAmount.append(number)
        }
    }

    func didTapDecimalSeparator(_ character: Character) {
        guard !self.displayAmount.contains(character) else { return }
        self.displayAmount.append(character)
    }

    func didTapDelete() {
        var copiedAmount = self.displayAmount
        copiedAmount.removeLast()
        if copiedAmount == "" {
            copiedAmount = "0"
        }
        self.displayAmount = copiedAmount
    }

    func didSelectToken(_ token: Token) {
        self.selectedToken = token
        self.resetAmount()
    }

    func resetAmount() {
        self.displayAmount = "0"
    }

    private func checkIfReady() {
        guard let token = self.selectedToken else {
            self.isReady = false
            self.isAmountValid = false
            return
        }
        self.isReady = true
        self.isAmountValid = OMGNumberFormatter().number(from: self.displayAmount, subunitToUnit: token.subUnitToUnit) != 0
    }
}
