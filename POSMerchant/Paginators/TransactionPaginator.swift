//
//  TransactionPaginator.swift
//  POSMerchant
//
//  Created by Mederic Petit on 5/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO

class TransactionPaginator: Paginator<Transaction> {
    private let transactionLoader: TransactionLoaderProtocol

    init(transactionLoader: TransactionLoaderProtocol,
         successClosure: ObjectClosure<[Transaction]>?,
         failureClosure: FailureClosure?) {
        self.transactionLoader = transactionLoader
        super.init(page: 1, perPage: Constant.perPage, successClosure: successClosure, failureClosure: failureClosure)
    }

    override func load() {
        let params = PaginatedListParams<Transaction>(page: self.page,
                                                      perPage: self.perPage,
                                                      sortBy: .createdAt,
                                                      sortDirection: .descending)
        self.currentRequest = self.transactionLoader.list(withParams: params) { response in
            switch response {
            case let .success(data: transactionList):
                self.didReceiveResults(results: transactionList.data, pagination: transactionList.pagination)
            case let .fail(error: error):
                self.didFail(withError: error)
            }
        }
    }
}
