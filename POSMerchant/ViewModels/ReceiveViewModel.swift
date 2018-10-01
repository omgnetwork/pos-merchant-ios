//
//  ReceiveViewModel.swift
//  POSMerchant
//
//  Created by Mederic Petit on 27/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
import UIKit

class ReceiveViewModel: BaseViewModel, ReceiveViewModelProtocol {
    let title: String = "receive.label.receive".localized()
    let receiveButtonTitle: String = "receive.button.receive".localized()
    var displayAmount: String {
        didSet {
            self.onAmountUpdate?(self.displayAmount)
        }
    }

    var tokenString: String
    var onAmountUpdate: ObjectClosure<String>?
    var onTokenUpdate: ObjectClosure<String>?
    var onFailGetDefaultToken: FailureClosure?
    var selectedToken: Token? {
        didSet {
            self.tokenString = self.selectedToken?.name ?? "-"
            self.onTokenUpdate?(self.tokenString)
        }
    }

    var isReady: Bool { return self.selectedToken != nil }

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
        let paginationParams = PaginatedListParams<Wallet>(page: 1,
                                                           perPage: 1,
                                                           searchTerms: [.identifier: "primary"],
                                                           sortBy: .address,
                                                           sortDirection: .ascending)
        let params = WalletListForAccountParams(paginatedListParams: paginationParams,
                                                accountId: self.sessionManager.selectedAccount?.id ?? "",
                                                owned: false)
        self.tokenLoader.listForAccount(withParams: params) { result in
            switch result {
            case let .success(data: paginatedWallets):
                guard let token = paginatedWallets.data.first?.balances.first?.token else {
                    self.onFailGetDefaultToken?(POSMerchantError.message(message: "receive.error.no_token".localized()))
                    return
                }
                self.selectedToken = token
            case let .fail(error: error):
                self.onFailGetDefaultToken?(.omiseGO(error: error))
            }
        }
    }

    func didTapNumber(_ number: String) {
        if self.displayAmount == "0" {
            if number == "0" { return }
            self.displayAmount = number
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
    }
}
