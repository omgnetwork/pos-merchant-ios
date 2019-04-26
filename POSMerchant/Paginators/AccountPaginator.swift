//
//  AccountPaginator.swift
//  POSMerchant
//
//  Created by Mederic Petit on 26/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO

class AccountPaginator: Paginator<Account> {
    private let accountLoader: AccountLoaderProtocol

    init(accountLoader: AccountLoaderProtocol,
         successClosure: ObjectClosure<[Account]>?,
         failureClosure: FailureClosure?) {
        self.accountLoader = accountLoader
        super.init(page: 1, perPage: Constant.perPage, successClosure: successClosure, failureClosure: failureClosure)
    }

    override func load() {
        let params = PaginatedListParams<Account>(page: self.page,
                                                  perPage: self.perPage,
                                                  sortBy: .createdAt,
                                                  sortDirection: .descending)
        self.currentRequest = self.accountLoader.list(withParams: params) { response in
            switch response {
            case let .success(data: transactionList):
                self.didReceiveResults(results: transactionList.data, pagination: transactionList.pagination)
            case let .failure(error):
                self.didFail(withError: error)
            }
        }
    }
}
