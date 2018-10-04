//
//  SelectAccountViewModel.swift
//  POSMerchant
//
//  Created by Mederic Petit on 26/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
import UIKit

class SelectAccountViewModel: BaseViewModel, SelectAccountViewModelProtocol {
    // Delegate closures
    var appendNewResultClosure: ObjectClosure<[IndexPath]>?
    var reloadTableViewClosure: EmptyClosure?
    var onFailLoadAccounts: FailureClosure?
    var onLoadStateChange: ObjectClosure<Bool>?

    let viewTitle: String = "select_account.view.title".localized()

    private var accountCellViewModels: [AccountCellViewModel]! = [] {
        didSet {
            if accountCellViewModels.isEmpty { self.reloadTableViewClosure?() }
        }
    }

    var isLoading: Bool = false {
        didSet { self.onLoadStateChange?(self.isLoading) }
    }

    var paginator: AccountPaginator!
    private let sessionManager: SessionManagerProtocol

    init(accountLoader: AccountLoaderProtocol = AccountLoader(),
         sessionManager: SessionManagerProtocol = SessionManager.shared) {
        self.sessionManager = sessionManager
        super.init()
        self.paginator = AccountPaginator(accountLoader: accountLoader,
                                          successClosure: { [weak self] accounts in
                                              self?.process(accounts: accounts)
                                              self?.isLoading = false
                                          }, failureClosure: { [weak self] error in
                                              self?.process(error: error)
                                              self?.isLoading = false
                                          }
        )
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
        accounts.forEach({
            newCellViewModels.append(AccountCellViewModel(account: $0))
        })
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
        self.sessionManager.selectCurrentAccount(self.accountCellViewModels[indexPath.row].account)
    }
}
