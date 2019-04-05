//
//  SelectAccountViewModel.swift
//  POSMerchant
//
//  Created by Mederic Petit on 26/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
import UIKit

enum SelectAccountMode {
    case currentAccount
    case exchangeAccount
}

protocol SelectAccountViewModelDelegate: AnyObject {
    func didSelectAccount(account: Account, forMode mode: SelectAccountMode)
}

class SelectAccountViewModel: BaseViewModel, SelectAccountViewModelProtocol {
    // Delegate closures
    var appendNewResultClosure: ObjectClosure<[IndexPath]>?
    var reloadTableViewClosure: EmptyClosure?
    var onFailLoadAccounts: FailureClosure?
    var onLoadStateChange: ObjectClosure<Bool>?

    var isLoading: Bool = false {
        didSet { self.onLoadStateChange?(self.isLoading) }
    }

    weak var delegate: SelectAccountViewModelDelegate?

    let viewTitle: String = "select_account.view.title".localized()

    let mode: SelectAccountMode

    private var accountCellViewModels: [AccountCellViewModel]! = [] {
        didSet {
            if self.accountCellViewModels.isEmpty { self.reloadTableViewClosure?() }
        }
    }

    private let sessionManager: SessionManagerProtocol
    private var paginator: AccountPaginator!

    required init(accountLoader: AccountLoaderProtocol = AccountLoader(),
                  sessionManager: SessionManagerProtocol = SessionManager.shared,
                  mode: SelectAccountMode = .currentAccount,
                  delegate: SelectAccountViewModelDelegate? = nil) {
        self.sessionManager = sessionManager
        self.mode = mode
        self.delegate = delegate
        super.init()
        self.paginator = AccountPaginator(accountLoader: accountLoader,
                                          successClosure: { [weak self] accounts in
                                              self?.process(accounts: accounts)
                                              self?.isLoading = false
                                          }, failureClosure: { [weak self] error in
                                              self?.process(error: error)
                                              self?.isLoading = false
        })
    }

    func reloadAccounts() {
        self.paginator.reset()
        self.accountCellViewModels = []
        self.getNextAccounts()
    }

    func getNextAccounts() {
        self.isLoading = true
        self.paginator.loadNext()
    }

    private func process(accounts: [Account]) {
        var newCellViewModels: [AccountCellViewModel] = []
        let exchangeAccountId = UserDefaultsWrapper().getValue(forKey: .exchangeAccountId)
        accounts.forEach {
            let isSelected: Bool = self.mode == .currentAccount ?
                $0.id == self.sessionManager.selectedAccount?.id :
                $0.id == exchangeAccountId
            newCellViewModels.append(AccountCellViewModel(account: $0, isSelected: isSelected))
        }
        var indexPaths: [IndexPath] = []
        for row in
        self.accountCellViewModels.count ..< (self.accountCellViewModels.count + newCellViewModels.count) {
            indexPaths.append(IndexPath(row: row, section: 0))
        }
        self.accountCellViewModels.append(contentsOf: newCellViewModels)
        self.appendNewResultClosure?(indexPaths)
    }

    private func process(error: POSMerchantError) {
        switch error {
        case let .omiseGO(error: omiseGOError):
            switch omiseGOError {
            case .other: return
            default: self.onFailLoadAccounts?(error)
            }
        default: self.onFailLoadAccounts?(error)
        }
    }

    private func updateSelection() {
        let exchangeAccountId = UserDefaultsWrapper().getValue(forKey: .exchangeAccountId)
        self.accountCellViewModels.forEach {
            $0.isSelected = self.mode == .currentAccount ?
                $0.account.id == self.sessionManager.selectedAccount?.id :
                $0.account.id == exchangeAccountId
        }
        self.reloadTableViewClosure?()
    }
}

extension SelectAccountViewModel {
    func accountCellViewModel(at indexPath: IndexPath) -> AccountCellViewModel {
        return self.accountCellViewModels[indexPath.row]
    }

    func numberOfRow() -> Int {
        return self.accountCellViewModels.count
    }

    func shouldLoadNext(atIndexPath indexPath: IndexPath) -> Bool {
        return self.numberOfRow() - indexPath.row < 5 && !self.paginator.reachedLastPage
    }

    func selectAccount(atIndexPath indexPath: IndexPath) {
        guard let account = self.accountCellViewModels[indexPath.row].account else { return }
        switch self.mode {
        case .currentAccount:
            self.sessionManager.selectCurrentAccount(account)
        case .exchangeAccount:
            UserDefaultsWrapper().storeValue(value: account.id, forKey: .exchangeAccountId)
            UserDefaultsWrapper().storeValue(value: account.name, forKey: .exchangeAccountName)
        }
        self.delegate?.didSelectAccount(account: account, forMode: self.mode)
        self.updateSelection()
    }
}
