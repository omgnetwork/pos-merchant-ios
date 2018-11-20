//
//  TestTransactionLoader.swift
//  POSMerchantTests
//
//  Created by Mederic Petit on 30/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO
@testable import POSMerchant

class TestTransactionLoader {
    var isListCalled = false

    var transactions: [Transaction]?
    var pagination: Pagination?
    var completionClosure: Transaction.PaginatedListRequestCallback!

    func loadTransactionSuccess() {
        self.completionClosure(
            OmiseGO.Response.success(
                data: JSONPaginatedListResponse<Transaction>(data: self.transactions!, pagination: self.pagination!)
            )
        )
    }

    func loadTransactionFailed(withError error: OMGError) {
        self.completionClosure(OmiseGO.Response.fail(error: error))
    }
}

extension TestTransactionLoader: TransactionLoaderProtocol {
    func list(withParams _: PaginatedListParams<Transaction>,
              callback: @escaping Transaction.PaginatedListRequestCallback)
        -> Transaction.PaginatedListRequest? {
        self.isListCalled = true
        self.completionClosure = callback
        return nil
    }
}
