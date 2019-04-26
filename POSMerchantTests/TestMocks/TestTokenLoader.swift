//
//  TestTokenLoader.swift
//  POSMerchantTests
//
//  Created by Mederic Petit on 26/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO
@testable import POSMerchant

class TestTokenLoader {
    var isListCalled = false

    private var callback: Wallet.PaginatedListRequestCallback?

    func success(withWallet wallets: [Wallet], pagination: Pagination) {
        let response = JSONPaginatedListResponse<Wallet>(data: wallets, pagination: pagination)
        self.callback?(OmiseGO.Response.success(response))
    }

    func failure(withError error: OMGError) {
        self.callback?(OmiseGO.Response.failure(error))
    }
}

extension TestTokenLoader: TokenLoaderProtocol {
    func listForAccount(withParams _: WalletListForAccountParams,
                        callback: @escaping Wallet.PaginatedListRequestCallback) -> Wallet.PaginatedListRequest? {
        self.isListCalled = true
        self.callback = callback
        return nil
    }
}
