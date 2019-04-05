//
//  TestAccountLoader.swift
//  POSMerchantTests
//
//  Created by Mederic Petit on 25/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO
@testable import POSMerchant

class TestAccountLoader {
    var isListCalled = false

    private var callback: Account.PaginatedListRequestCallback?

    func success(withAccount accounts: [Account], pagination: Pagination) {
        let response = JSONPaginatedListResponse<Account>(data: accounts, pagination: pagination)
        self.callback?(OmiseGO.Response.success(response))
    }

    func failure(withError error: OMGError) {
        self.callback?(OmiseGO.Response.failure(error))
    }
}

extension TestAccountLoader: AccountLoaderProtocol {
    func list(withParams _: PaginatedListParams<Account>,
              callback: @escaping Account.PaginatedListRequestCallback) -> Account.PaginatedListRequest? {
        self.isListCalled = true
        self.callback = callback
        return nil
    }
}
