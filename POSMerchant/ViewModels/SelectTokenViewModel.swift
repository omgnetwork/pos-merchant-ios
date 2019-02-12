//
//  SelectTokenViewModel.swift
//  POSMerchant
//
//  Created by Mederic Petit on 28/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO

protocol SelectTokenDelegate: class {
    func didSelectToken(_ token: Token)
}

class SelectTokenViewModel: BaseViewModel, SelectTokenViewModelProtocol {
    // Delegate closures
    var reloadTableViewClosure: EmptyClosure?
    var onFailLoadTokens: FailureClosure?
    var onLoadStateChange: ObjectClosure<Bool>?

    let viewTitle: String = "select_token.view.title".localized()

    private var balanceCellViewModels: [BalanceCellViewModel] = [] {
        didSet {
            self.reloadTableViewClosure?()
        }
    }

    private var isLoading: Bool = false {
        didSet { self.onLoadStateChange?(self.isLoading) }
    }

    private let sessionManager: SessionManagerProtocol
    private let tokenLoader: TokenLoaderProtocol
    private weak var delegate: SelectTokenDelegate?
    private let selectedToken: Token

    required init(tokenLoader: TokenLoaderProtocol = TokenLoader(),
                  sessionManager: SessionManagerProtocol = SessionManager.shared,
                  delegate: SelectTokenDelegate?,
                  selectedToken: Token) {
        self.sessionManager = sessionManager
        self.tokenLoader = tokenLoader
        self.delegate = delegate
        self.selectedToken = selectedToken
        super.init()
        self.loadBalances()
    }

    func loadBalances() {
        self.isLoading = true
        let primaryFilter = Wallet.filter(field: .identifier, comparator: .equal, value: "primary")
        let paginationParams = PaginatedListParams<Wallet>(page: 1,
                                                           perPage: 1,
                                                           filters: FilterParams(matchAll: [primaryFilter]),
                                                           sortBy: .address,
                                                           sortDirection: .ascending)
        let params = WalletListForAccountParams(paginatedListParams: paginationParams,
                                                accountId: self.sessionManager.selectedAccount?.id ?? "",
                                                owned: false)
        self.tokenLoader.listForAccount(withParams: params) { result in
            switch result {
            case let .success(data: paginatedWallets):
                guard let balances = paginatedWallets.data.first?.balances else {
                    self.onFailLoadTokens?(POSMerchantError.message(message: "select_token.error.no_token".localized()))
                    return
                }
                self.process(balances: balances)
            case let .fail(error: error):
                self.onFailLoadTokens?(.omiseGO(error: error))
            }
            self.isLoading = false
        }
    }

    private func process(balances: [Balance]) {
        var newCellViewModels: [BalanceCellViewModel] = []
        balances.forEach({
            newCellViewModels.append(BalanceCellViewModel(balance: $0,
                                                          isSelected: $0.token == self.selectedToken))
        })
        self.balanceCellViewModels = newCellViewModels
    }
}

extension SelectTokenViewModel {
    func tokenCellViewModel(at indexPath: IndexPath) -> BalanceCellViewModel {
        return self.balanceCellViewModels[indexPath.row]
    }

    func numberOfRow() -> Int {
        return self.balanceCellViewModels.count
    }

    func selectToken(atIndexPath indexPath: IndexPath) {
        self.delegate?.didSelectToken(self.balanceCellViewModels[indexPath.row].balance.token)
    }
}
