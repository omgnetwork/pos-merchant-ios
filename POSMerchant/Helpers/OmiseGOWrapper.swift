//
//  OmiseGOWrapper.swift
//  POSMerchant
//
//  Created by Mederic Petit on 25/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO

protocol AccountLoaderProtocol {
    func list(withParams params: PaginatedListParams<Account>,
              callback: @escaping Account.PaginatedListRequestCallback) -> Account.PaginatedListRequest?
}

/// This wrapper has been created for the sake of testing with dependency injection
class AccountLoader: AccountLoaderProtocol {
    @discardableResult
    func list(withParams params: PaginatedListParams<Account>,
              callback: @escaping Account.PaginatedListRequestCallback) -> Account.PaginatedListRequest? {
        return Account.list(using: SessionManager.shared.httpClient, params: params, callback: callback)
    }
}
