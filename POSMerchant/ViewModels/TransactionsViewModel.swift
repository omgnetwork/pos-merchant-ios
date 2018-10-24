//
//  TransactionsViewModel.swift
//  POSMerchant
//
//  Created by Mederic Petit on 5/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
import UIKit

class TransactionsViewModel: BaseViewModel, TransactionsViewModelProtocol {
    // Delegate closures
    var appendNewResultClosure: ObjectClosure<[IndexPath]>?
    var reloadTableViewClosure: EmptyClosure?
    var onFailLoadTransactions: FailureClosure?
    var onLoadStateChange: ObjectClosure<Bool>?

    let viewTitle: String = "transactions.view.title".localized()

    private var transactionCellViewModels: [TransactionCellViewModel]! = [] {
        didSet {
            if transactionCellViewModels.isEmpty { self.reloadTableViewClosure?() }
        }
    }

    var isLoading: Bool = false {
        didSet { self.onLoadStateChange?(self.isLoading) }
    }

    var paginator: TransactionPaginator!
    private let sessionManager: SessionManagerProtocol

    init(transactionLoader: TransactionLoaderProtocol = TransactionLoader(),
         sessionManager: SessionManagerProtocol = SessionManager.shared) {
        self.sessionManager = sessionManager
        super.init()
        self.paginator = TransactionPaginator(transactionLoader: transactionLoader,
                                              successClosure: { [weak self] transactions in
                                                  self?.process(transactions: transactions)
                                                  self?.isLoading = false
                                              }, failureClosure: { [weak self] error in
                                                  self?.process(error: error)
                                                  self?.isLoading = false
                                              }
        )
    }

    func reloadTransactions() {
        self.paginator.reset()
        self.transactionCellViewModels = []
        self.getNextTransactions()
    }

    func getNextTransactions() {
        self.isLoading = true
        self.paginator.loadNext()
    }

    private func process(transactions: [Transaction]) {
        guard let account = self.sessionManager.selectedAccount else { return }
        var newCellViewModels: [TransactionCellViewModel] = []
        transactions.forEach({
            newCellViewModels.append(TransactionCellViewModel(transaction: $0,
                                                              currentAccount: account))
        })
        var indexPaths: [IndexPath] = []
        for row in
        self.transactionCellViewModels.count ..< (self.transactionCellViewModels.count + newCellViewModels.count) {
            indexPaths.append(IndexPath(row: row, section: 0))
        }
        self.transactionCellViewModels.append(contentsOf: newCellViewModels)
        self.appendNewResultClosure?(indexPaths)
    }

    private func process(error: POSMerchantError) {
        switch error {
        case let .omiseGO(error: omiseGOError):
            switch omiseGOError {
            case .other: return
            default: self.onFailLoadTransactions?(error)
            }
        default: self.onFailLoadTransactions?(error)
        }
    }
}

extension TransactionsViewModel {
    func transactionCellViewModel(at indexPath: IndexPath) -> TransactionCellViewModel {
        return self.transactionCellViewModels[indexPath.row]
    }

    func numberOfRow() -> Int {
        return self.transactionCellViewModels.count
    }

    func shouldLoadNext(atIndexPath indexPath: IndexPath) -> Bool {
        return self.numberOfRow() - indexPath.row < 5 && !self.paginator.reachedLastPage
    }
}
