//
//  TransactionsViewModelProtocol.swift
//  POSMerchant
//
//  Created by Mederic Petit on 5/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

protocol TransactionsViewModelProtocol {
    var appendNewResultClosure: ObjectClosure<[IndexPath]>? { get set }
    var reloadTableViewClosure: EmptyClosure? { get set }
    var onFailLoadTransactions: FailureClosure? { get set }
    var onLoadStateChange: ObjectClosure<Bool>? { get set }

    var viewTitle: String { get }

    func reloadTransactions()
    func getNextTransactions()
    func transactionCellViewModel(at indexPath: IndexPath) -> TransactionCellViewModel
    func numberOfRow() -> Int
    func shouldLoadNext(atIndexPath indexPath: IndexPath) -> Bool
}
